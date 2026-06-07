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
