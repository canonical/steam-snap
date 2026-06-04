# Does a FRESH REBUILD, which will clear the local rootfs components and download the new latest artifacts from remote.
# To update the remote rootfs components, run tarx86.sh and upload those artifacts.
# Download checksums of artifacts. If mismatched, download actual artifacts.
# TODO download step

snapcraft clean
# Extract the artifacts
rm -rf amd64_rootfs
rm -rf steam_218_amd64
tar -xvf steam_218_amd64.tar.gz
tar -xvf amd64_rootfs.tar.gz 
snapcraft
