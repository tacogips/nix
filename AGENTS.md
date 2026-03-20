# AGENTS.md for the repository root

This file is the canonical instruction entry point for AI assistants working in
the repository root and its subdirectories.

## Response Rules

- The first response in a conversation must state that you have read this file
  and will comply with it.
- Think and respond in English unless the user explicitly asks for another
  language.
- If the user's instruction is given in English, begin the first response with
  `Your instruction is {corrected English}` using a grammatically corrected
  version of the user's request.
- If code changes are made, complete the verification steps in this file before
  finishing.

## Code Change Procedure

After any code change, do all applicable steps below without waiting for a
follow-up request:

1. Follow the repository's code style.
2. Verify flake evaluation with `nix flake check` in the relevant flake root.
3. Run relevant tests if they exist.
4. Run relevant linting if configured.
5. Format changed files according to project standards.
6. Update documentation when the change affects behavior, structure, or usage.
7. Never create a git commit unless the user explicitly asks for one.

### Test Handling

- Do not weaken or remove failing tests just to make the suite pass.
- If tests fail after multiple reasonable fixes, stop and ask the user.
- Add tests for new behavior and edge cases when appropriate.
- If a test appears wrong, discuss it before changing it.

## Repository Overview

This repository manages NixOS and nix-darwin systems with Nix flakes.

### Key Features

- Multi-platform support for Linux and macOS
- Home Manager integration across platforms
- Shared configuration modules in `nixos/shared-home-manager/`
- GitHub CLI-based HTTPS authentication for Git operations
- Modular layout with shared and platform-specific configuration

### Directory Structure

```text
repo/
├── ignite/             # Initial NixOS bootstrap configuration
├── nixos/              # Main NixOS and nix-darwin configurations
│   ├── linux/          # Linux-specific system configuration
│   │   ├── flake.nix   # Linux flake root
│   ├── darwin/         # macOS-specific system configuration
│   │   ├── flake.nix   # Darwin flake root
│   └── shared-home-manager/  # Shared, platform-independent Home Manager modules
└── ...
```

## Build And Update Commands

### Initial Build

```bash
cd ignite
bash ignite.sh
```

### Build Taco Main Dev Machine

```bash
sudo nixos-rebuild switch --flake ~/nix/nixos/linux#taco-main
```

### Update Flake Dependencies

Update a specific input:

```bash
cd nixos/linux
nix flake lock --update-input cratedocs-mcp
```

Update all inputs:

```bash
cd nixos/linux
nix flake update
```

## GitHub Authentication

This repository uses HTTPS GitHub authentication with `GITHUB_TOKEN` instead of
SSH keys for Git operations.

### Initial Setup

```bash
gh auth login
gh-token-export
```

### Notes

- SSH-style GitHub URLs are converted automatically to HTTPS
- Credentials are read from `GITHUB_TOKEN`
- This setup supports private repositories when token scopes are sufficient

### Relevant Configuration Files

- `nixos/shared-home-manager/taco/git/default.nix`
- `nixos/shared-home-manager/taco/git/github-credential.config`

### Golang Private Repositories

```bash
export GOPRIVATE=github.com/your-org/*
```

## Nix-Specific Guidance

### Flake Roots

- The repository root is not a flake root.
- Linux flake root: `nixos/linux`
- Darwin flake root: `nixos/darwin`

### Git Tracking Requirement

- Nix flakes only recognize files tracked by Git.
- New files may need to be staged or committed before some flake operations can
  see them.

### Path Resolution

- Relative imports in flake-based code should be reasoned about from the flake
  root.

### Rebuild Commands

- Linux: run `nixos-rebuild switch --flake .#nix-dev-machine` from
  `nixos/linux`
- Darwin: run `darwin-rebuild switch --flake .#taco-mac` from `nixos/darwin`

### Diagnostics

- Use `nix flake check` before applying changes when possible.
- If Linux evaluation requires private configuration, document that constraint in
  the final response.

## Structure Guidance

- Keep platform-independent configuration in `nixos/shared-home-manager/`.
- Keep Linux-specific configuration in `nixos/linux/`.
- Keep Darwin-specific configuration in `nixos/darwin/`.
- Prefer small, self-contained modules over unrelated edits in large files.
- Shared Home Manager modules belong under `nixos/shared-home-manager/taco/`.

## Darwin Notes

- Use `darwin.lib.darwinSystem` for Darwin systems.
- Use `home-manager.darwinModules.home-manager` for Home Manager on macOS.
- Conflicting shared settings may need `lib.mkForce`.
- Build first with
  `nix build .#darwinConfigurations.taco-mac.system` when appropriate.

## Documentation

- Update documentation when changing directory structure or workflow.
- Document platform-specific requirements and compatibility constraints.
