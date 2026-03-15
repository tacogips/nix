# CLAUDE.md for /home/taco/nix

This file serves as the primary instruction file for AI assistants working in this directory.

## Instructions

**IMPORTANT**: You must read and follow the instructions in `/home/taco/nix/nixos/CLAUDE.md`.

All development work in this directory and its subdirectories must comply with the guidelines, rules, and procedures defined in that file.

## Directory Overview

This is a NixOS and nix-darwin configuration repository for managing system configurations across multiple platforms (Linux and macOS). The repository uses Nix flakes for declarative system and home management.

### Key Features

- **Multi-platform support**: Configurations for both NixOS (Linux) and nix-darwin (macOS)
- **Home Manager integration**: User environment management across platforms
- **Shared configuration modules**: Platform-independent settings in `nixos/shared-home-manager/`
- **GitHub CLI authentication**: Uses GitHub CLI instead of SSH keys for git operations
- **Modular structure**: Organized by platform with shared and platform-specific configurations

### Directory Structure

```
/home/taco/nix/
├── ignite/             # Initial NixOS bootstrap configuration
├── nixos/              # Main NixOS and nix-darwin configurations
│   ├── linux/          # Linux-specific system configuration
│   ├── darwin/         # macOS-specific system configuration
│   └── shared-home-manager/  # Shared, platform-independent Home Manager modules
├── flake.nix           # Nix flake definition
└── flake.lock          # Flake input lock file
```

## Build and Update Commands

### Initial Build (First NixOS Installation)

```bash
cd ignite
bash ignite.sh
```

### Build Taco Main Dev Machine

```bash
sudo nixos-rebuild switch --flake ~/nix/nixos/linux#taco-main
```

### Update Flake Dependencies

Update specific input:
```bash
nix flake lock --update-input cratedocs-mcp
```

Update all inputs:
```bash
nix flake update
```

## GitHub Authentication Setup

This configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable instead of SSH keys for git operations.

### Initial Setup

1. Authenticate with GitHub CLI if needed:
```bash
gh auth login
```

2. Export a token into the environment:
```bash
gh-token-export
```

### How It Works

- **No SSH keys required**: Git operations use HTTPS protocol with a git credential helper
- **Automatic URL conversion**: SSH URLs (`git@github.com:`) are automatically converted to HTTPS (`https://github.com/`)
- **Credential source**: `~/.config/git/github-credential.config` reads credentials from `GITHUB_TOKEN`
- **Works for private repositories**: Full access to private repositories with proper token scopes (repo, read:org, gist)

### Configuration Files

- `nixos/shared-home-manager/taco/git/default.nix`: Configures automatic SSH to HTTPS URL conversion
- `nixos/shared-home-manager/taco/git/github-credential.config`: Managed git credential helper config that reads `GITHUB_TOKEN`

### For Golang Private Repositories

Set the `GOPRIVATE` environment variable for your private Go modules:
```bash
export GOPRIVATE=github.com/your-org/*
```

Go will automatically use the git credential helper when fetching private modules.

## Reference

See: `/home/taco/nix/nixos/CLAUDE.md` for detailed instructions on:
- Response rules and language requirements
- Code change procedures
- Git commit policies and message formats
- Directory structure policies
- Nix-specific command considerations
- Best practices for modularity and cross-platform configuration
- Darwin (macOS) configuration guidelines
- Developer notes for adding new packages
