# Darwin configuration

This flake defines nix-darwin hosts for macOS.

## Layout

Reusable Darwin components are split by responsibility:

```text
hosts/
  taco-mac/              # Host-specific imports and profile choices
lib/
  mkDarwinConfiguration.nix
                          # Shared darwinSystem builder
modules/
  base/                  # Common nix-darwin system defaults
  apps/                  # Reusable app installation modules
packages/
  base.nix               # Common system packages
  fonts.nix              # Common Darwin fonts
  flake-inputs.nix       # Packages sourced from flake inputs
  overlays.nix           # Darwin-specific nixpkgs overlays
profiles/
  taco-apps.nix          # App profile for the main desktop Mac
  home-server.nix        # App profile for the Mac home server
```

Add a new host by creating `hosts/<host-name>/default.nix` and registering it in
`flake.nix` through `lib/mkDarwinConfiguration.nix`.

## App modules

Reusable app installation modules live in `modules/apps/`. Each app exposes a
host-level option under `taco.darwin.apps.<app>.enable`, so non-`taco-mac`
Darwin hosts can opt into only the apps they need.

Example server-oriented host module:

```nix
{
  imports = [
    ./modules/apps
  ];

  taco.darwin.apps = {
    container-tools.enable = true;
    ghostty.enable = true;
    rielflow.enable = true;
  };
}
```

The `profiles/taco-apps.nix` profile enables the full app set currently used by
`taco-mac`.

The desktop app profile includes Peekaboo from `steipete/tap/peekaboo`. Shared
Home Manager Cursor configuration exposes that Homebrew-installed binary as a
Cursor MCP server with `peekaboo mcp serve --transport stdio`.

The desktop app profile also installs Cursor through Homebrew Cask: `cursor`
for the app and `cursor-cli` for `cursor-agent`. When that app module is
enabled, shared Home Manager does not install the Nixpkgs `cursor-cli` package
on Darwin, so the active CLI comes from Homebrew.

App modules that use private Homebrew taps should add the tap to both
`taco.darwin.homebrew.taps` and `taco.darwin.homebrew.trustedTaps`. The shared
Homebrew wrapper trusts those taps as the configured Homebrew user before
`brew bundle` runs, which avoids activation failures when
`HOMEBREW_REQUIRE_TAP_TRUST` is enforced.

## Home Server Host

`darwin-mac-home-server` is a server-oriented host for the Mac home-server
layout with mirrored data storage, a separate backup disk, iPhone photo/video
ingest, lightweight photo viewing, Jellyfin video viewing, and Tailscale-first
remote access.

It imports `profiles/home-server.nix`, which enables:

- Homebrew-managed host dependencies: `caddy`, `tailscale`, `ffmpeg`, `rclone`,
  `restic`, `filebrowser`, `smartmontools`, `rsync`, `jq`, and `yq`.
- Homebrew-managed container tools through `taco.darwin.apps.container-tools`:
  `container`, `colima`, `docker`, `docker-compose`, `podman`, and
  `podman-compose`.
- The Jellyfin macOS app through Homebrew Cask.
- Generated runtime scaffolding under the primary user's `~/home-server`.
- Generated templates under `/etc/darwin-mac-home-server`.

The host assumes the data and backup disks are mounted here:

```text
/Volumes/Data
/Volumes/Backup
```

If those volumes are mounted during activation, the module creates:

```text
/Volumes/Data/Photos
/Volumes/Data/Videos
/Volumes/Data/Files
/Volumes/Backup/home-server
```

Build it with:

```bash
cd ~/nix/nixos/darwin
nix build --impure .#darwinConfigurations.darwin-mac-home-server.system
```

Switch to it with:

```bash
sudo /run/current-system/sw/bin/darwin-rebuild switch --impure --flake ~/nix/nixos/darwin#darwin-mac-home-server
```

## Package files

Common packages and fonts are intentionally kept out of host modules:

- `packages/base.nix` is for baseline CLI packages that every Darwin host should
  have.
- `packages/fonts.nix` is for shared font packages.
- `packages/flake-inputs.nix` converts flake inputs such as `kinko` and
  `bravesearch-mcp` into package arguments for Home Manager.
- `packages/overlays.nix` contains Darwin-only nixpkgs overlays.

Server-specific packages for a future `darwin-home-server` host should be added
as a new package file or profile instead of extending `profiles/taco-apps.nix`.
