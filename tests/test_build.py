"""Build entry-point regression tests; no Snapcraft installation required."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[1]


class BuildScriptTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.fake_snapcraft = Path(self.directory.name) / "snapcraft"
        self.fake_snapcraft.write_text(
            '#!/bin/bash\n'
            'printf "%s\\n" "$PWD" "$@"\n'
            'exit "${TEST_EXIT:-0}"\n'
        )
        self.fake_snapcraft.chmod(0o755)
        self.env = dict(os.environ)
        self.env["PATH"] = self.directory.name + os.pathsep + self.env["PATH"]
        self.env["TEST_EXIT"] = "0"

    def run_build(self, *args):
        return subprocess.run(
            [str(PROJECT / "build.sh"), *args],
            cwd=self.directory.name,
            env=self.env,
            capture_output=True,
            text=True,
            check=False,
        )

    def test_isolated_build_from_another_directory(self):
        result = self.run_build("--output", "test snap.snap")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            result.stdout.splitlines(),
            [str(PROJECT), "pack", "--use-lxd", "--output", "test snap.snap"],
        )

    def test_snapcraft_failure_is_propagated(self):
        self.env["TEST_EXIT"] = "42"
        self.assertEqual(self.run_build().returncode, 42)


if __name__ == "__main__":
    unittest.main()
