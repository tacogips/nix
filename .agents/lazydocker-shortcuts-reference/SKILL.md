---
name: lazydocker-shortcuts-reference
description: Explain and list Lazydocker shortcuts for this repository, distinguishing repo-local config from upstream default keybindings. Use when a user asks for a Lazydocker shortcut list, what a Lazydocker key does, or whether this repo customizes Lazydocker keys.
---

# Lazydocker Shortcuts Reference

Use this skill when the task is to explain or inventory Lazydocker shortcuts for this repository.

## Source Of Truth

Read these in order:

1. `nixos/shared-home-manager/taco/lazydocker/default.nix`
2. `~/.config/lazydocker/config.yml` if present on the current machine
3. `references/shortcuts-reference.md`

In this repository, the Nix module is the local override layer. If the question is specifically about "this repo", check it first before describing upstream defaults.

## Current Repo State

`nixos/shared-home-manager/taco/lazydocker/default.nix` configures theme colors only. It does not define custom keybindings.

That means shortcut answers for this repo are normally:

- repo-local overrides: none found
- effective shortcuts: upstream Lazydocker defaults, unless runtime config says otherwise

Say that explicitly instead of implying the repo owns the defaults.

## Recommended Workflow

1. Read `nixos/shared-home-manager/taco/lazydocker/default.nix`.
2. If the user wants the exact runtime answer, inspect `~/.config/lazydocker/config.yml` when available.
3. Use `references/shortcuts-reference.md` for the compact default shortcut list.
4. If the user wants an exhaustive list, link the official keybinding sheet in the reference file.

## What To Report

Prefer this structure:

- repo-local overrides, if any
- global/focus keys
- panel-specific keys for the requested area: project, services, containers, images, volumes, networks, main
- runtime caveat if no generated config was inspected

## Constraints

- Do not invent repo-local Lazydocker keybindings; this repo currently has none in source.
- If you rely on upstream defaults, say so.
- If the user asks for "all shortcuts", provide a compact grouped list and link the official sheet rather than pretending memory is exhaustive.

## File References

- `nixos/shared-home-manager/taco/lazydocker/default.nix`
- `references/shortcuts-reference.md`
