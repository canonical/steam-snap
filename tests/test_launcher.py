"""Exercise the launchers with fake bubblewrap, FEX, and Steam executables."""

import io
import json
import os
from pathlib import Path
import shutil
import subprocess
import tarfile
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[1]


class LauncherTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.snap = self.root / "snap"
        self.common = self.root / "common"
        self.shadow = self.common / "x86_rootfs" / str(self.common).lstrip("/")
        self.shadow_steam = self.shadow / ".steam"
        self.arguments = self.root / "arguments.json"
        self.bwrap_arguments = self.root / "bwrap-arguments.json"
        for path in [
            self.snap / "bin", self.snap / "usr/bin", self.snap / "usr/lib/steam",
            self.snap / "usr/share/Steam/skins/Yaru", self.snap / "fex_config",
            self.common / ".fex-emu/nvidia_ngx_config", self.common / "x86_rootfs",
            self.common / "Desktop", self.common / ".local/share/applications",
            self.common / ".local/share/icons", self.root / "data",
            self.root / "home/.config", self.root / "home/Desktop",
            self.root / "home/.local/share/icons/hicolor", self.root / "runtime",
        ]:
            path.mkdir(parents=True, exist_ok=True)
        for path in [self.snap / "x86_rootfs.tar.gz", self.common / "x86_rootfs.tar.gz"]:
            path.write_bytes(b"unchanged rootfs")
        (self.common / ".fex-emu/nvidia_ngx_config/ngx_lib_version.txt").write_text("test-driver\n")
        (self.root / "home/.config/user-dirs.dirs").write_text('XDG_DESKTOP_DIR="$HOME/Desktop"\n')
        shutil.copy2(PROJECT / "src/desktop-launch", self.snap / "bin/desktop-launch")
        self.write_executable("usr/bin/FEXBash", '#!/bin/bash\nexec /bin/bash "$@"\n')
        self.write_executable(
            "usr/bin/bwrap",
            '#!/usr/bin/python3\nimport json, os, sys\n'
            'with open(os.environ["BWRAP_ARGUMENTS_FILE"], "w") as f:\n'
            '    json.dump(sys.argv[1:], f)\n'
            'command = sys.argv[sys.argv.index("--") + 1:]\n'
            'os.execv(command[0], command)\n',
        )
        self.write_executable("usr/bin/getconf", '#!/bin/bash\necho 4096\n')
        self.write_executable("usr/bin/snapctl", '#!/bin/bash\nexit 0\n')
        self.write_executable(
            "usr/bin/cat",
            '#!/bin/bash\nif [[ "$1" == /sys/module/nvidia/version ]]; then\n'
            '  echo test-driver\nelse\n  exec /bin/cat "$@"\nfi\n',
        )
        self.write_executable(
            "usr/lib/steam/bin_steam.sh",
            '#!/usr/bin/python3\nimport json, os, sys\n'
            'with open(os.environ["ARGUMENTS_FILE"], "w") as f:\n'
            '    json.dump(sys.argv[1:], f)\n'
            'sys.exit(int(os.environ.get("TEST_STEAM_EXIT", "0")))\n',
        )
        self.env = dict(os.environ, SNAP=str(self.snap), SNAP_USER_COMMON=str(self.common),
                        SNAP_USER_DATA=str(self.root / "data"), SNAP_REAL_HOME=str(self.root / "home"),
                        SNAP_ARCH="arm64", SNAP_REVISION="1", HOME=str(self.root / "home"),
                        XDG_RUNTIME_DIR=str(self.root / "runtime"), DISABLE_WAYLAND="1",
                        ARGUMENTS_FILE=str(self.arguments),
                        BWRAP_ARGUMENTS_FILE=str(self.bwrap_arguments), TEST_STEAM_EXIT="0")
        self.env["PATH"] = str(self.snap / "usr/bin") + os.pathsep + os.defpath

    def write_executable(self, path, text):
        target = self.snap / path
        target.write_text(text)
        target.chmod(0o755)

    def launch(self, *args):
        return subprocess.run(
            ["bash", str(PROJECT / "fex_config/usr/bin/fex_launcher.sh"), *args],
            env=self.env, capture_output=True, text=True, timeout=15,
        )

    def test_arguments_reach_steam_intact(self):
        args = ["-applaunch", "1091500", "--launcher-skip", "argument with spaces", "", "$(not-a-command)"]
        result = self.launch(*args)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.arguments.read_text()), ["-no-cef-sandbox", *args])
        self.assertFalse(self.shadow.is_symlink())
        self.assert_home_bind()

    def test_shadow_data_is_preserved_and_home_mapping_survives_relaunch(self):
        self.shadow.mkdir(parents=True)
        (self.shadow / "save-marker").write_text("preserve me")
        result = self.launch()
        self.assertEqual(result.returncode, 0, result.stderr)
        backups = list(self.common.glob("fex-shadow-backup.*/common/save-marker"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(), "preserve me")
        self.assert_home_bind()
        result = self.launch()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(list(self.common.glob("fex-shadow-backup.*"))), 1)
        self.assert_home_bind()

    def test_custom_driver_option_is_not_forwarded_to_steam(self):
        result = self.launch("--nvdriver", "https://example.invalid/driver.run", "-silent")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.arguments.read_text()), ["-no-cef-sandbox", "-silent"])

    def test_existing_sdk_data_is_preserved(self):
        sdk = self.shadow_steam / "sdk64"
        sdk.mkdir(parents=True)
        (sdk / "save-marker").write_text("preserve SDK data")
        result = self.launch()
        self.assertEqual(result.returncode, 0, result.stderr)
        backups = list(self.common.glob("fex-shadow-backup.*/common/.steam/sdk64/save-marker"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(), "preserve SDK data")
        self.assert_home_bind()

    def test_mapping_is_created_after_rootfs_refresh(self):
        # A refresh removes the old rootfs: the home mount must be prepared
        # afterwards, not just during initial launcher setup.
        with tarfile.open(self.snap / "x86_rootfs.tar.gz", "w:gz") as archive:
            data = b"new rootfs"
            member = tarfile.TarInfo("x86_rootfs/version-marker")
            member.size = len(data)
            archive.addfile(member, io.BytesIO(data))
        self.write_executable("usr/bin/zenity", '#!/bin/bash\nexit 0\n')
        result = self.launch()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.common / "x86_rootfs/version-marker").read_bytes(), data)
        self.assert_home_bind()

    def assert_home_bind(self):
        self.assertTrue(self.shadow.is_dir())
        self.assertFalse(self.shadow.is_symlink())
        args = json.loads(self.bwrap_arguments.read_text())
        self.assertEqual(args[:13], [
            "--bind", "/", "/", "--dev-bind", "/dev", "/dev", "--proc", "/proc",
            "--bind", str(self.common), str(self.shadow), "--", str(self.snap / "usr/bin/FEXBash"),
        ])

    def test_steam_failure_is_propagated(self):
        self.env["TEST_STEAM_EXIT"] = "42"
        self.assertEqual(self.launch().returncode, 42)


if __name__ == "__main__":
    unittest.main()
