#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVICE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PRIVATE_DIR="${DEVICE_DIR}/.private"
OUT_FILE="${PRIVATE_DIR}/private.nix"

if [[ "${1:-}" != "" && "${1:-}" != "--force" ]]; then
  echo "Usage: $0 [--force]" >&2
  exit 1
fi

if [[ -f "${OUT_FILE}" && "${1:-}" != "--force" ]]; then
  echo "Refusing to overwrite ${OUT_FILE}. Re-run with --force." >&2
  exit 1
fi

mkdir -p "${PRIVATE_DIR}"

uuid_for_mount() {
  local mount_point="$1"
  findmnt -no UUID "${mount_point}" 2>/dev/null || true
}

root_uuid="$(uuid_for_mount /)"
boot_uuid="$(uuid_for_mount /boot)"
d_uuid="$(uuid_for_mount /d)"
g_uuid="$(uuid_for_mount /g)"

if [[ -z "${root_uuid}" || -z "${boot_uuid}" ]]; then
  echo "Could not detect root or boot UUID. Check mounts and retry." >&2
  exit 1
fi

host_name="$(hostnamectl --static 2>/dev/null || hostname)"
default_source=""
if command -v pactl >/dev/null 2>&1; then
  default_source="$(pactl get-default-source 2>/dev/null || true)"
  if [[ -z "${default_source}" ]]; then
    default_source="$(pactl list short sources 2>/dev/null | awk 'NR==1 {print $2}')"
  fi
fi

{
  echo "{ lib, ... }:"
  echo "{"
  echo "  networking.hostName = lib.mkForce \"${host_name}\";"
  echo
  echo "  fileSystems.\"/\".device = lib.mkForce \"/dev/disk/by-uuid/${root_uuid}\";"
  echo "  fileSystems.\"/\".fsType = lib.mkDefault \"ext4\";"
  echo
  echo "  fileSystems.\"/boot\".device = lib.mkForce \"/dev/disk/by-uuid/${boot_uuid}\";"
  echo "  fileSystems.\"/boot\".fsType = lib.mkDefault \"vfat\";"
  echo "  fileSystems.\"/boot\".options = lib.mkDefault [ \"fmask=0077\" \"dmask=0077\" ];"
  echo
  if [[ -n "${d_uuid}" ]]; then
    echo "  fileSystems.\"/d\".device = lib.mkForce \"/dev/disk/by-uuid/${d_uuid}\";"
    echo "  fileSystems.\"/d\".fsType = lib.mkDefault \"ext4\";"
    echo
  fi
  if [[ -n "${g_uuid}" ]]; then
    echo "  fileSystems.\"/g\".device = lib.mkForce \"/dev/disk/by-uuid/${g_uuid}\";"
    echo "  fileSystems.\"/g\".fsType = lib.mkDefault \"ext4\";"
    echo
  fi
  if [[ -n "${default_source}" ]]; then
    echo "  services.pipewire.extraConfig.pipewire.\"context.modules\" = ["
    echo "    {"
    echo "      name = \"libpipewire-module-metadata\";"
    echo "      args = {"
    echo "        \"metadata.name\" = \"default-restore\";"
    echo "        \"metadata.values\" = ["
    echo "          {"
    echo "            key = \"default.audio.source\";"
    echo "            value = ''{ \"name\": \"${default_source}\" }'';"
    echo "          }"
    echo "        ];"
    echo "      };"
    echo "    }"
    echo "  ];"
  fi
  echo "}"
} > "${OUT_FILE}"

echo "Wrote ${OUT_FILE}"
echo
echo "Use this when evaluating/rebuilding:"
echo "NIXOS_PRIVATE_CONFIG=\"${OUT_FILE}\" nix eval --impure .#nixosConfigurations.nix-dev-machine.config.networking.hostName"
