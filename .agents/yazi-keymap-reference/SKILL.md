---
name: yazi-keymap-reference
description: Explain and list this repository's Yazi keymaps, including repo-local overrides and the shipped Yazi defaults. Use when a user asks what a Yazi key does, wants a Yazi keymap inventory, or wants to know the grep/find/search bindings in this repo.
---

# Yazi Keymap Reference

Use this skill when the task is to explain or inventory Yazi keybindings for this repository.

## Source Of Truth

Read these in order:

1. `nixos/shared-home-manager/taco/yazi/keymap.nix`
2. `nixos/shared-home-manager/taco/yazi/default.nix`
3. `~/.config/yazi/keymap.toml` if present on the current machine
4. `references/keymap-reference.md`

Treat `nixos/shared-home-manager/taco/yazi/keymap.nix` as the repo-local override layer. Do not answer from upstream defaults alone if the question is about "this repo" or "my Yazi".

## Current Repo Overrides

The repo currently adds these manager keymaps on top of Yazi defaults:

- `<Enter>`: `plugin enter-directory`
- `, g`: `plugin git-diff-tree`
- `, r`: `search --via=rg`

Keep these separate from upstream defaults when reporting. If a key exists both in the repo override and upstream defaults, say which one wins.

## What To Report

When the user asks for a list, prefer this structure:

- Repo-local overrides first
- Then the relevant shipped default keys by category
- Then any runtime/generated config caveat if you did not inspect `~/.config/yazi/keymap.toml`

Useful categories:

- navigation
- open/enter
- search/find/filter
- selection/yank/paste
- tabs/tasks/help

## Expected Search/Find Answers

These are the most common lookups in this repo:

- `, r`: repo-local ripgrep content search
- `S`: shipped ripgrep content search
- `s`: shipped `fd` filename search
- `/`: shipped `find --smart`
- `?`: shipped `find --previous --smart`
- `n` / `N`: shipped next/previous match

If the user says "grep", prefer `search --via=rg` and mention both `, r` (repo-local) and `S` (shipped default).

## Recommended Workflow

1. Read `nixos/shared-home-manager/taco/yazi/keymap.nix`.
2. If the question mentions behavior like enter/open/plugins, read `nixos/shared-home-manager/taco/yazi/default.nix`.
3. If the user wants the effective runtime keymap, inspect `~/.config/yazi/keymap.toml` when available.
4. Use `references/keymap-reference.md` for the compact default key list instead of trying to restate the entire upstream TOML from memory.
5. For exhaustive answers, link the official Yazi docs and shipped default keymap noted in the reference file.

## Constraints

- Do not claim the repo overrides replace the whole Yazi keymap; they are prepend overrides.
- Do not confuse `find` with `search`: `find` moves within the visible list, `search` builds/searches a result set through an engine like `fd` or `rg`.
- If you did not inspect runtime-generated config, say the answer is based on repo source plus shipped defaults.

## File References

- `nixos/shared-home-manager/taco/yazi/keymap.nix`
- `nixos/shared-home-manager/taco/yazi/default.nix`
- `references/keymap-reference.md`
