The amd64-rootfs artifact can be generated as follows:
1. Install fex-emu-armv8.0 from ppa:fex-emu/fex
2. Run FEXRootFSFetcher to download a rootfs
3.
Added this:
cat amd64_rootfs/x86_rootfs/usr/share/vulkan/icd.d/nvidia_icd.json
{
    "file_format_version" : "1.0.1",
    "ICD": {
        "library_path": "libGLX_nvidia.so.0",
        "api_version" : "1.4.312"
    }
}
^ This is what fixed the "missing vulkan" errors
4. On an amd64 machine, `snap download gaming-graphics-core24 --channel kisak-fresh/candidate
5. unsquashfs the components into the correct directories in the x86 rootfs
6. Re-tar and upload to remote

The steam-amd64 artifact can be generated as follows:
1. On an amd64 machine, `snap download steam`
2. unsquashfs the artifact
3. Copy src/desktop-launch script into same location *within* amd64 directory
4. Re-tar and upload to remove


This was added as an automatic step to fex_config/usr/bin/fex_launcher.sh (as part of NGX DLL update):
amd64_rootfs/x86_rootfs/usr/lib/x86_64-linux-gnu/nvidia/wine was rwx for owner only, for some reason. some version of it will be needed for DLSS (but we should bind mount).
With it sitting in that location, it fails to get copied and causes proton launches to fail until we chmod +r everything in it.
