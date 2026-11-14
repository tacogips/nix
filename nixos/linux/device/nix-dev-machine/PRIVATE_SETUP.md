# Private Machine Values Setup

This repository keeps machine-specific values out of version control.

## 1. Create `private.nix`

```bash
cd /home/taco/nix/nixos/linux/device/nix-dev-machine
./scripts/generate-private-nix.sh

# overwrite if needed
# ./scripts/generate-private-nix.sh --force
```

`.private/private.nix` is ignored by git because this repository already ignores `**/.private**`.
This config is loaded via `NIXOS_PRIVATE_CONFIG` (absolute path) and `--impure`.

If you want additional local-only ignore rules without editing tracked `.gitignore`,
use `.git/info/exclude`:

```bash
cd /home/taco/nix
printf "\n# local-only ignores\nnixos/linux/device/nix-dev-machine/.private/\n" >> .git/info/exclude
```

## 2. Collect UUID values

Show all block devices and UUIDs:

```bash
lsblk -f
```

Alternative (detailed):

```bash
sudo blkid
```

Useful direct commands:

```bash
# Root filesystem UUID (mounted at /)
findmnt -no SOURCE / | xargs -I{} blkid -s UUID -o value {}

# Boot filesystem UUID (mounted at /boot)
findmnt -no SOURCE /boot | xargs -I{} blkid -s UUID -o value {}
```

The script writes detected UUID values into `.private/private.nix`.
If needed, edit that file manually afterward.

## 3. Collect hostname and audio source

```bash
# Hostname
hostnamectl --static

# PipeWire/PulseAudio source list
pactl list short sources
```

The script also tries to set your default audio source automatically.

## 4. Validate before rebuild

```bash
cd /home/taco/nix/nixos/linux
NIXOS_PRIVATE_CONFIG="/home/taco/nix/nixos/linux/device/nix-dev-machine/.private/private.nix" \
  nix eval --impure .#nixosConfigurations.nix-dev-machine.config.networking.hostName
```

Rebuild example:

```bash
cd /home/taco/nix/nixos/linux
sudo NIXOS_PRIVATE_CONFIG="/home/taco/nix/nixos/linux/device/nix-dev-machine/.private/private.nix" \
  nixos-rebuild switch --impure --flake .#nix-dev-machine
```
