---
name: nvim-keymap-skill
description: Maintain and explain this repository's nvf-based Neovim keymap conventions. Use when a user wants to add, move, remove, audit, or document Neovim keymaps, especially when keeping Helix-like Space mode and goto-style g-prefixed navigation consistent.
---

# Nvim Keymap Skill

Use this skill when editing or explaining custom Neovim keymaps in this repository.

## Source Of Truth

- Put custom Neovim keymaps in `nixos/shared-home-manager/taco/nvf/keymaps.nix`.
- Keep plugin files under `nixos/shared-home-manager/taco/nvf/plugins/` focused on plugin setup, not local key ownership.
- If a plugin currently defines a repo-local keymap and it can be expressed as a normal `settings.vim.keymaps` entry, move it into `keymaps.nix`.
- Treat `nixos/shared-home-manager/taco/nvf/keymaps.nix` as the file to read first when listing or auditing mappings.

## Current Layout Rules

- `Space` is the main picker/action namespace, modeled after Helix Space mode.
- `g` is the goto/jump namespace, modeled after Helix goto mode.
- `m` is the match/surround/textobject namespace, modeled after Helix match mode.
- `z` is reserved for Helix-like view-mode aliases when view-only scrolling or alignment helpers are needed.
- `,` is fallback space for commands that do not fit the Helix-like layout or would collide with more important `Space`/`g` bindings.
- Keep insert-mode ergonomics and command-line remaps at the top of `keymaps.nix`.
- Add a short comment above each mapping describing intent, not just the literal action.

## Preferred Placement

### `Space` namespace

Use `Space` first for pickers and LSP actions:

- Telescope pickers: file, buffer, grep, branch, marks, history, keymaps, symbols, diagnostics
- file-browser-like entry points such as `:Yazi cwd`
- LSP actions such as hover, rename, and code actions
- repo-local utility commands that are not jumps, such as `QuickRun`, clipboard helpers, and `LspRestart`, if they do not collide with a more important `Space` binding

Examples already used in this repo:

- `Space e` for `:Yazi cwd`
- `Space f` for tracked files
- `Space g` for git status
- `Space G` for git branches
- `Space gc` for git commits
- `Space /` for live grep
- `Space a` for code action
- `Space r` for rename
- `Space k` for hover
- `Space p` / `Space P` for system clipboard paste
- `Space y` / `Space Y` for system clipboard yank
- `Space C` for copying the current working directory
- `Space R` for QuickRun
- `Space \` for `LspRestart`

### `g` namespace

Use `g` for location changes and jump-like motions:

- `gd` definition
- `gy` type definition
- `gr` references
- `gi` implementations
- `gn` / `gp` next and previous diagnostics
- `gj` / `gf` Hop-based jump motions

If a mapping is fundamentally about moving focus to another location, prefer `g` over `Space`.

### `m` namespace

Use `m` for match-oriented editing helpers, especially bracket matching, surround operations, and textobject entry points.

Examples already used in this repo:

- `mm` matching bracket jump
- `ms` surround add prefix
- `mr` surround replace prefix
- `md` surround delete prefix
- `ma` around-textobject visual selection prefix
- `mi` inside-textobject visual selection prefix

### `z` namespace

Use `z` for Helix-like view manipulation that changes the viewport without changing the editing target.

Examples already used in this repo:

- `zc` vertical centering
- `zj` / `zk` view-only scrolling
- `zm` horizontal alignment helper

### `,` namespace

Use `,` only when:

- the natural `Space` or `g` slot is already occupied by a more important mapping
- the command is repo-specific and not meaningfully Helix-like
- the mapping is an overflow command such as `QuickRun`

## Editing Workflow

1. Read `nixos/shared-home-manager/taco/nvf/keymaps.nix`.
2. Search `nixos/shared-home-manager/taco/nvf/plugins/` for stray keymaps.
3. If changing placement, preserve the existing namespace logic above.
4. Update comments so the intent stays obvious in-file.
5. If keymap ownership moved out of a plugin file, remove the old plugin-local keymap.
6. When the user asks for an inventory, include mappings from both `keymaps.nix` and any remaining plugin-local keymaps.

## Verification

After keymap edits:

- Run `nixfmt` on changed Nix files.
- Run `nix flake check` in `nixos/darwin`.
- Run `nix flake check` in `nixos/linux`.
- If Linux evaluation fails because `NIXOS_PRIVATE_CONFIG` is missing, report that explicitly instead of masking it.

## File References

- `nixos/shared-home-manager/taco/nvf/keymaps.nix`
- `nixos/shared-home-manager/taco/nvf/default.nix`
- `nixos/shared-home-manager/taco/nvf/plugins/`
