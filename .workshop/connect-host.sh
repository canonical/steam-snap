#!/bin/bash

# Mounts host Steam paths into the Workshop VM. Also copies the host OpenCode
# config and optionally its saved provider connections into the Workshop.

set -euo pipefail

usage() {
    echo "Usage: $0 [--with-provider-connections [PROVIDER]]"
}

copy_connections=false
provider=()
case ${1-} in
    '') ;;
    -h|--help)
        usage
        exit 0
        ;;
    --with-provider-connections)
        copy_connections=true
        if [[ $# == 2 && -n $2 && $2 != -* ]]; then
            provider=("$2")
        elif [[ $# != 1 ]]; then
            usage >&2
            exit 2
        fi
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ws=(workshop --project "$project_dir")
info=$("${ws[@]}" info dev)

status=$(awk '$1 == "status:" { print $2 }' <<< "$info")
case $status in
    ready|waiting|stopped) ;;
    *)
        echo 'Launch the dev workshop before connecting host files.' >&2
        exit 1
        ;;
esac
project_id=$(cat "$project_dir/.workshop.lock")
if [[ ! "$project_id" =~ ^[a-f0-9]{8}$ ]]; then
    echo "Invalid Workshop project ID" >&2
    exit 1
fi
mount_dir="${XDG_DATA_HOME:-$HOME/.local/share}/workshop/id/$project_id/dev/mount"

mount_source() {
    awk -v sdk="$1:" -v plug="$2:" '
        /^  [^ ]/ { in_sdk = ($1 == sdk); in_plug = 0 }
        /^      [^ ]/ { in_plug = in_sdk && ($1 == plug) }
        in_plug && sub(/^        host-source:[[:blank:]]+/, "") { print; exit }
    ' <<< "$info"
}

display_path() {
    case $1 in
        "$HOME"/*) printf '%s/%s\n' '~' "${1#"$HOME"/}" ;;
        *) printf '%s\n' "$1" ;;
    esac
}

mount_steam() {
    local plug=$1 source=$2 current backing="$mount_dir/snapcraft/$1"
    if [[ ! -d "$source" ]]; then
        printf 'Skipping missing host directory: %s\n' "$source" >&2
        return
    fi
    current=$(mount_source snapcraft "$plug")
    if [[ $current == "$(display_path "$source")" ]]; then
        return
    fi
    if [[ $current != "$(display_path "$backing")" ]]; then
        printf 'Unexpected mount source for snapcraft:%s; check workshop info dev.\n' "$plug" >&2
        return 1
    fi
    # Avoid replacing an existing host directory with Workshop's default source.
    if [[ -e "$backing" || -L "$backing" ]]; then
        rmdir -- "$backing"
    fi
    "${ws[@]}" remount "dev/snapcraft:$plug" "$source"
}

config_mount="$mount_dir/opencode/opencode-config"
if [[ $(mount_source opencode opencode-config) != "$(display_path "$config_mount")" ]]; then
    echo 'OpenCode must use its workshop-owned config mount' >&2
    exit 1
fi

if [[ $copy_connections == true ]]; then
    if ! command -v opencode >/dev/null; then
        echo 'Install OpenCode on the host before copying provider connections.' >&2
        exit 1
    fi
    data_mount="$mount_dir/opencode/opencode-data"
    if [[ $(mount_source opencode opencode-data) != "$(display_path "$data_mount")" ]]; then
        echo 'OpenCode must use its workshop-owned data mount to import provider connections.' >&2
        exit 1
    fi
fi

mount_steam steam-user "$HOME/snap/steam"
mount_steam steam-data /var/snap/steam
mount_steam steam-snap /snap/steam
mount_steam gaming-graphics /snap/gaming-graphics-core26

if [[ $status == stopped ]]; then
    "${ws[@]}" start dev
fi

copy_config() (
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
    [[ -d "$config_dir" ]] || return 0

    config_entries=(opencode.json opencode.jsonc cli.json AGENTS.md agents commands instructions plugins skills themes)
    files=()
    for entry in "${config_entries[@]}"; do
        if [[ -e "$config_dir/$entry" || -L "$config_dir/$entry" ]]; then
            files+=("$entry")
        fi
    done

    archive=$(mktemp)
    trap 'rm -f -- "$archive"' EXIT
    tar -chf "$archive" -C "$config_dir" -T /dev/null -- "${files[@]}"
    sync_config=$(cat <<'EOF'
    set -euo pipefail
    dest=$HOME/.config/opencode
    staging=$(mktemp -d)
    trap 'rm -rf -- "$staging"' EXIT
    tar -xf - -C "$staging"
    for entry; do
        rm -rf -- "$dest/$entry"
        if [[ -e "$staging/$entry" ]]; then
            mv -- "$staging/$entry" "$dest/$entry"
        fi
    done
EOF
    )
    "${ws[@]}" exec -I dev -- bash -c "$sync_config" bash "${config_entries[@]}" < "$archive"
)

copy_config

if [[ $copy_connections == true ]]; then
    # Do not expose credentials in CLI diagnostics.
    if ! opencode auth export --standalone "${provider[@]}" 2>/dev/null |
        "${ws[@]}" exec -I dev -- opencode auth import --standalone >/dev/null 2>&1; then
        echo 'Could not copy OpenCode provider connections. Check the host and Workshop with opencode auth list --standalone.' >&2
        exit 1
    fi
fi
