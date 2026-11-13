#!/bin/bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Snapcraft downloads the amd64 artifacts declared in snap/snapcraft.yaml.
# Reuse the isolated build environment; run `snapcraft clean --use-lxd` first
# when a fresh rebuild is required.
exec snapcraft pack --use-lxd "$@"
