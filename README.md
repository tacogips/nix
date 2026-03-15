# Initial NixOS bootstrap

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

# update

nix flake lock --update-input cratedocs-mcp
nix flake update

# GitHub Authentication Setup

This configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable instead of SSH keys.

## Initial Setup

1. On a machine that only has Nix installed, temporarily install `gh` and `kinko` with Nix flakes:
```bash
nix shell nixpkgs#gh github:tacogips/kinko
```

2. Authenticate with GitHub CLI:
```bash
gh auth login
```

3. Save the current GitHub CLI token into kinko shared secrets as `GITHUB_TOKEN`:
```bash
kinko set-key GITHUB_TOKEN --shared --value "$(gh auth token)"
```

4. After Home Manager is applied, open a new shell so fish can export shared kinko secrets automatically.
   If you only want to populate the current shell from GitHub CLI without touching kinko, use:
```bash
gh-token-export
```

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
