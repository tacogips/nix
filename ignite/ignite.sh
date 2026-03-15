#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
target_nixos_dir="${repo_root}/nixos"
backup_dir="/etc/nixos_orig"

if [[ ! -d "${target_nixos_dir}" ]]; then
  echo "Expected NixOS config directory at '${target_nixos_dir}', but it was not found." >&2
  exit 1
fi

if [[ -L /etc/nixos ]]; then
  current_target="$(readlink -f /etc/nixos)"
  if [[ "${current_target}" == "${target_nixos_dir}" ]]; then
    echo "/etc/nixos already points to ${target_nixos_dir}. Nothing to do."
    exit 0
  fi

  echo "/etc/nixos is already a symlink to '${current_target}'. Refusing to overwrite it." >&2
  exit 1
fi

if [[ -e "${backup_dir}" ]]; then
  echo "${backup_dir} already exists. Move or remove it before running this script." >&2
  exit 1
fi

if [[ ! -e /etc/nixos ]]; then
  echo "/etc/nixos does not exist. Create it first or update this script for your environment." >&2
  exit 1
fi

echo "Backing up /etc/nixos to ${backup_dir}"
sudo mv /etc/nixos "${backup_dir}"

echo "Linking ${target_nixos_dir} to /etc/nixos"
sudo ln -s "${target_nixos_dir}" /etc/nixos

echo "Bootstrap complete. Next step:"
echo "  sudo nixos-rebuild switch --flake ${target_nixos_dir}/linux#taco-main"
