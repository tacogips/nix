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

## Nix maintenance

The shared base module registers the system launchd daemon
`org.nixos.nix-garbage-collector`. It runs `nix-collect-garbage` every Sunday
at 03:15 and writes its output to `/var/log/nix-garbage-collector.log`. It only
removes unreferenced store paths; it does not delete profile generations.

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
    kinko.enable = true;
    riela.enable = true;
  };
}
```

The `profiles/taco-apps.nix` profile enables the full app set currently used by
`taco-mac`.

The Darwin profiles use Herdr as their terminal multiplexer. Homebrew installs
the `herdr` formula, Ghostty starts or attaches to Herdr automatically, and Home
Manager writes `~/.config/herdr/config.toml`. `Alt+T` creates a workspace,
`Alt+J` moves down to the next workspace, `Alt+K` moves up to the previous
workspace, and `Alt+1`
through `Alt+9` switch tabs directly. New tabs use Herdr's default `Prefix+C`
binding, and `Alt+R` renames the current tab. `Alt+F` toggles the focused pane
between zoomed and normal size.
Darwin no longer enables tmux or its `pam_reattach` support, and activation
removes the retired `com.taco.tmux-window-title` launch agent.

The desktop app profile installs CCUsage Gauge from the
`tacogips/tap/ccusage-gauge` Homebrew Cask. The existing `ccusage` app module
installs the CLI that CCUsage Gauge reads for its usage data.

The desktop app profile installs Bitwarden from the Mac App Store and the
Bitwarden Secrets Manager CLI (`bws`) from the `tonyxiao/tap/bws` Homebrew
formula.

The desktop app profile installs Tailscale from the Mac App Store. The
home-server profile uses the same App Store variant rather than the Homebrew
formula. During activation, the Tailscale module stops and removes an existing
Homebrew formula installation before installing the App Store app.

The desktop app profile includes Peekaboo from `steipete/tap/peekaboo`. Shared
Home Manager Cursor configuration exposes that Homebrew-installed binary as a
Cursor MCP server with `peekaboo mcp serve --transport stdio`.

The desktop app profile also installs Cursor through Homebrew Cask: `cursor`
for the app and `cursor-cli` for `cursor-agent`. When that app module is
enabled, shared Home Manager does not install the Nixpkgs `cursor-cli` package
on Darwin, so the active CLI comes from Homebrew.

The desktop app profile installs the Cline client through the Homebrew formula
`cline`.

The desktop app profile installs Claude Desktop through the Homebrew Cask
`claude`. This is separate from `claude-code`, which installs the terminal-based
Claude Code tool from the rolling `claude-code@latest` Cask. During activation,
the Claude Code module removes an existing stable `claude-code` Cask before
Homebrew installs the latest release channel.

The shared Neovim configuration enables the Java `jdtls` LSP server, but on
Darwin the server binary is installed through Homebrew's bottled `jdtls`
formula instead of Nixpkgs `jdt-language-server` to avoid a large local Nix
toolchain closure during rebuilds.

The desktop app profile installs Riela through the `tacogips/tap/riela`
Homebrew Cask. Riela 0.1.5 split delivery so the Homebrew Formula is CLI-only,
while the Cask installs both `RielaApp.app` and the `riela` CLI. The app module
removes the old formula during activation when present so the cask can link its
CLI binary cleanly.

The desktop app profile also enables `taco.darwin.apps.xcode`, which installs
Xcode from the Mac App Store and selects
`/Applications/Xcode.app/Contents/Developer` during activation when the app is
present. The same module exports `DEVELOPER_DIR`, `SDKROOT`, and `TOOLCHAINS`
for the fixed Mac App Store Xcode install and prepends Xcode's default
toolchain `bin` directory to the system path. Nix does not package the full
Swift/Xcode toolchain on Darwin; it supplies repository utilities such as
`git`, `jq`, `ripgrep`, and `shellcheck`, while `swift`, `swift test`,
`sourcekit-lsp`, `xcodebuild`, and iOS Simulator/SDK access come from the host
Xcode install.

Check the host toolchain with:

```bash
xcode-select -p
xcrun --find swift
xcrun --find sourcekit-lsp
xcodebuild -version
```

For iOS app repositories that provide their own `flake.nix` dev shell, use
`nix develop` for lint and verification utilities and rely on host Xcode for
builds, tests, and Simulator work.

App modules that use private Homebrew taps should add the tap to both
`taco.darwin.homebrew.taps` and `taco.darwin.homebrew.trustedTaps`. The shared
Homebrew wrapper trusts those taps as the configured Homebrew user before
`brew bundle` runs, which avoids activation failures when
`HOMEBREW_REQUIRE_TAP_TRUST` is enforced.

The `taco-apps` profile installs the published `apple-gateway`,
`x-gateway-reader`, `x-gateway-writer`, `mail-gateway-reader`,
`mail-gateway-draft`, and `mail-gateway-sender` formulae from `tacogips/tap`.
Their authentication keys belong in Kinko shared scope so the commands work
outside their source checkouts; interactive Fish shells import shared Kinko
secrets automatically.

Darwin Home Manager also installs `apple-gateway` Codex user skills as real
files under `~/.agents/skills/`. The common `apple-gateway` skill handles CLI
diagnostics and permissions; `apple-calendar`, `apple-reminders`, `apple-notes`,
`apple-schedule`, `apple-mail`, `apple-notifications`, and
`apple-clock-alarms` provide focused workflows for each Apple app domain.
Calendar containers and scheduled events are deliberately separate skills.
Skill files are replaced atomically during Home Manager activation so agent
skill discovery never observes a removed intermediate path. They use the
installed CLI and its live GraphQL schema, while the source checkout at
`~/gits/tacogips/apple-gateway` remains available for implementation details
and troubleshooting.

## Home Server Host

`darwin-mac-home-server` is a server-oriented host for the Mac home-server
layout with mirrored data storage, a separate backup disk, iPhone photo/video
ingest, lightweight photo viewing, Jellyfin video viewing, and Tailscale-first
remote access.

It imports `profiles/home-server.nix`, which enables:

- Agent and editor tooling matching the main Darwin host: Homebrew-managed
  Codex CLI and app, Claude Code, Cursor, and Cursor CLI. Fish and the
  NVF-backed Neovim configuration are inherited from the shared Darwin base and
  Home Manager modules.
- Homebrew-managed host dependencies: `caddy`, `ffmpeg`, `rclone`,
  `restic`, `filebrowser`, `smartmontools`, `rsync`, `jq`, and `yq`.
- Tailscale through the Mac App Store.
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
- `packages/flake-inputs.nix` converts flake inputs into package arguments for
  Home Manager when needed. Homebrew-managed tools such as `kinko`, `ign`, and
  the Riela Cask are exposed through app modules instead.
- `packages/overlays.nix` contains Darwin-only nixpkgs overlays.

Server-specific packages for a future `darwin-home-server` host should be added
as a new package file or profile instead of extending `profiles/taco-apps.nix`.
