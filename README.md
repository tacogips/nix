# Bootstrap

## Flakes Prerequisite

Before any `nix shell nixpkgs#...` command in this README, enable flakes once for your user:

```bash
mkdir -p ~/.config/nix
printf 'experimental-features = nix-command flakes\n' >> ~/.config/nix/nix.conf
```

The `nix shell` commands below install `go-task` temporarily. After flakes are enabled, you can also normalize this setting with a task from either platform directory:

```bash
cd ~/nix/nixos/linux
nix shell nixpkgs#go-task --command task enable-flakes-user

cd ~/nix/nixos/darwin
nix shell nixpkgs#go-task --command task enable-flakes-user
```

## NixOS

Use `ignite` once when migrating a fresh NixOS install to this repository-managed `/etc/nixos`.

1. Enable flakes first. See `ignite/manual-op.md`.
2. Run the bootstrap script from the repository root:

```bash
cd ~/nix/ignite
bash ignite.sh
```

3. Apply the machine configuration:

```bash
sudo nixos-rebuild switch --flake ~/nix/nixos/linux#taco-main
```

## nix-darwin

Use this path on macOS after Nix is installed.

Note: Tauri desktop end-to-end tests that rely on `tauri-driver` do not run on
macOS. Upstream Tauri only supports that WebDriver flow on Linux and Windows
because macOS does not provide a `WKWebView` WebDriver implementation.

1. Move to the Darwin configuration directory:

```bash
cd ~/nix/nixos/darwin
```

2. Install Homebrew first, because the nix-darwin flake checks for it during activation:

```bash
nix shell nixpkgs#go-task --command task first-time-setup
```

3. Back up the `/etc` files that nix-darwin will replace:

```bash
nix shell nixpkgs#go-task --command task backup-etc
```

4. Run the first nix-darwin activation from the repository checkout:

```bash
nix shell nixpkgs#go-task --command task build
```

5. Later updates can use:

```bash
nix shell nixpkgs#go-task --command task rebuild
```

If a GUI terminal such as Ghostty opens `fish` and shows `fish: Unknown command: nix`, apply the nix-darwin configuration again and open a fresh Ghostty window so fish reloads the Nix profile script.

6. To remove rebuild generations older than the latest 5 and garbage-collect unused Nix store paths:

```bash
nix shell nixpkgs#go-task --command task clean
```

## State Versions

`system.stateVersion` and `home.stateVersion` are compatibility values, not
"upgrade to latest" values. The tracked default stays at `24.11` for NixOS and
Home Manager, and `4` for nix-darwin system state.

Only change a machine's value when that machine was first installed on a
different release, or when you are doing an intentional compatibility migration
after reading the relevant release notes.

To keep machine-specific state versions out of Git, copy the example file to an
untracked absolute path and use `NIX_STATE_VERSIONS_CONFIG` with `--impure`:

```bash
cp ~/nix/nixos/state-versions.nix.example ~/.config/nix/state-versions.nix
export NIX_STATE_VERSIONS_CONFIG="$HOME/.config/nix/state-versions.nix"
```

Different machines may legitimately need different values. Update the matching
host entry in that local file when installing NixOS or nix-darwin on a machine
whose first-install release differs from the default.

# update

nix flake lock --update-input cratedocs-mcp
nix flake update

# GitHub Authentication Setup

This configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable instead of SSH keys.

Because this repository is now public, you do not need `GITHUB_TOKEN` before the initial `nixos-rebuild` or `darwin-rebuild` just to check out and apply this repository itself.

You still need to seed `kinko` shared secrets with `GITHUB_TOKEN` if you want this environment to clone or fetch other private GitHub repositories later.

## NixOS

1. Move to the Linux configuration directory:

```bash
cd ~/nix/nixos/linux
```

2. When you want to register `GITHUB_TOKEN` in `kinko` shared secrets, temporarily install `gh`, `kinko`, and `go-task` with Nix flakes, then run the Taskfile target:
```bash
nix shell nixpkgs#gh nixpkgs#go-task github:tacogips/kinko --command task setup-github-token
```

3. After Home Manager is applied, open a new shell so fish can export shared kinko secrets automatically.
   If you only want to populate the current shell from GitHub CLI, use `gh-token-export`.

## nix-darwin

1. Move to the Darwin configuration directory:

```bash
cd ~/nix/nixos/darwin
```

2. When you want to register `GITHUB_TOKEN` in `kinko` shared secrets, temporarily install `gh`, `kinko`, and `go-task` with Nix flakes, then run the Taskfile target:
```bash
nix shell nixpkgs#gh nixpkgs#go-task github:tacogips/kinko --command task setup-github-token
```

3. Apply the nix-darwin configuration, then open a new fish shell so shared kinko secrets are exported automatically.
   If you only want to populate the current shell from GitHub CLI, use `gh-token-export`.

For routine cleanup on either platform, run `nix shell nixpkgs#go-task --command task clean` from `~/nix/nixos/linux` or `~/nix/nixos/darwin`.

## How It Works

- **No SSH keys required**: Git operations use HTTPS with a git credential helper
- **Automatic URL conversion**: SSH URLs (`git@github.com:`) are automatically converted to HTTPS (`https://github.com/`)
- **Credential source**: Git reads `GITHUB_TOKEN`, which can be exported from kinko shared secrets or set with `gh-token-export`
- **Works for private repositories**: Full access to private repositories with proper token scopes (repo, read:org, gist)

## Configuration Files

- `nixos/shared-home-manager/taco/git/default.nix`: Configures automatic SSH to HTTPS URL conversion
- `nixos/shared-home-manager/taco/fish/default.nix`: Exports shared secrets from kinko into fish sessions when `kinko` is available

## For Golang Private Repositories

Set the `GOPRIVATE` environment variable for your private Go modules:
```bash
export GOPRIVATE=github.com/your-org/*
```

Go will automatically use the git credential helper when fetching private modules.
