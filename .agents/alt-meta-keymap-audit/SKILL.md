---
name: alt-meta-keymap-audit
description: Audit Alt/Meta (M-*) keymap conflicts for this repository's tmux, Yazi, Neovim (nvf), Zed/zeditor, and Lazygit setup. Use when a user wants to know which files define Alt bindings, how to inspect them, or whether bindings collide across terminal, tmux, editor, and file-manager layers.
---

# Alt/Meta Keymap Audit

Use this skill when the task is to inspect or explain `Alt`/`Meta`/`M-*` keymap conflicts in this repository.

## Scope

Treat the audit as a layered input path, not just an app-local keymap check:

1. Window manager or OS-level shortcuts may consume `Alt`.
2. The terminal emulator may bind `Alt` before the app sees it.
3. `tmux` may bind `M-*` globally before an app inside the pane sees it.
4. The app itself may bind the same key.

A same-key mapping is only a real conflict if both bindings can fire in the same context. Report the layer and context explicitly.

## Repository Files To Inspect

Primary app configs:

- `nixos/shared-home-manager/taco/tmux/default.nix`
- `nixos/shared-home-manager/taco/yazi/default.nix`
- `nixos/shared-home-manager/taco/yazi/keymap.nix`
- `nixos/shared-home-manager/taco/nvf/default.nix`
- `nixos/shared-home-manager/taco/nvf/keymaps.nix`
- `nixos/shared-home-manager/taco/nvf/plugins/yazi.nix`
- `nixos/shared-home-manager/taco/zed/default.nix`
- `nixos/shared-home-manager/taco/zed/keymap.nix`
- `nixos/shared-home-manager/taco/lazygit/default.nix`

Adjacent interception layers that can shadow app bindings:

- `nixos/shared-home-manager/taco/ghostty/default.nix`
- `nixos/linux/home-manager/default.nix`
- `nixos/darwin/home-manager/aerospace.nix`

Read the adjacent layer files whenever the user wants a definitive conflict answer instead of an app-only inventory.

## Current Repo Hotspots

These are the first places to verify before doing any broader search:

- `tmux` binds global `M-*` keys for splits, window jumps, pane focus, zoom, rename, and new windows.
- `zed` binds many `alt-*` keys in `Workspace`, panel, and terminal contexts.
- `neovim` itself does not broadly use `M-*` here, but `nixos/shared-home-manager/taco/nvf/plugins/yazi.nix` binds `<M-e>`.
- `yazi` has local custom keymap overrides, but no repo-defined `Alt` binding in `nixos/shared-home-manager/taco/yazi/keymap.nix`.
- `lazygit` has theme config only in this repo; no repo-defined custom `Alt` bindings.
- `ghostty` binds `alt+s`, which can shadow app-level `Alt-s`.
- Darwin `Aerospace` uses several `alt-shift-*` and `alt-ctrl-*` bindings.

## Recommended Workflow

### 1. Collect repo-defined Alt bindings

Use `rg` first.

```bash
rg -n "M-|<M-|alt-|Alt |Meta|meta" \
  nixos/shared-home-manager/taco/tmux \
  nixos/shared-home-manager/taco/yazi \
  nixos/shared-home-manager/taco/nvf \
  nixos/shared-home-manager/taco/zed \
  nixos/shared-home-manager/taco/lazygit \
  nixos/shared-home-manager/taco/ghostty \
  nixos/linux/home-manager \
  nixos/darwin/home-manager -S
```

Then read the exact defining files, not just grep output.

### 2. Normalize notation before comparing

Treat these as equivalent unless the target app distinguishes them:

- `M-e`
- `<M-e>`
- `alt-e`

Keep modifier order normalized when reporting, for example `alt-ctrl-t`.

### 3. Build a collision table by layer

For each key, record:

- key
- layer: `wm`, `terminal`, `tmux`, `app`
- owner
- context
- source file
- action

Useful collision classes:

- `hard conflict`: same layer and overlapping context
- `shadowed by upper layer`: terminal or tmux grabs the key first
- `context-separated`: same key exists but contexts do not overlap
- `no repo override`: no local binding found in this repository

### 4. Verify effective generated config when needed

If the machine has already applied Home Manager, inspect the rendered files too:

```bash
sed -n '1,220p' ~/.config/tmux/tmux.conf
sed -n '1,220p' ~/.config/yazi/keymap.toml
sed -n '1,260p' ~/.config/zed/keymap.json
sed -n '1,220p' ~/.config/lazygit/config.yml
```

For Neovim in this repo, the source-of-truth is usually the Nix source under `nixos/shared-home-manager/taco/nvf/`, especially:

- `nixos/shared-home-manager/taco/nvf/keymaps.nix`
- `nixos/shared-home-manager/taco/nvf/plugins/yazi.nix`

### 5. Escalate to runtime/default-keymap inspection only if necessary

Absence of a binding in this repo does not prove the application default is unbound.

If the user asks for a definitive runtime answer:

- check the installed app's effective config or generated config
- inspect the app's built-in defaults for the installed version
- state clearly when a conclusion is based only on repo overrides

This matters most for `yazi` and `lazygit`, because this repo currently defines little or no custom `Alt` behavior for them.

## Expected Findings In This Repo

Use these as hypotheses to confirm, not assumptions to report blindly:

- `tmux` is likely to shadow app-level `Alt-h/j/k/l`, `Alt-f`, `Alt-r`, `Alt-t`, and `Alt-i` inside tmux panes because they are bound with `bind -n`.
- `ghostty` `alt+s` is likely to shadow Zed terminal `alt-s` when the key is pressed in Ghostty before the app receives it.
- `zed` `alt-r` and `tmux` `M-r` are likely a conflict only when Zed runs inside tmux.
- Neovim `<M-e>` can conflict with any upper layer binding of `Alt-e`; in this repo `tmux` does not claim `M-e`, but Zed does use `alt-e`.

## Report Format

When answering the user, prefer a compact table or flat bullet list with:

- key
- conflicting owners
- whether it is a real conflict
- why
- source file references

Example phrasing:

- `Alt-s`: `ghostty` vs `zed Terminal`; likely shadowed by terminal layer if Zed is launched inside Ghostty. Sources: `nixos/shared-home-manager/taco/ghostty/default.nix`, `nixos/shared-home-manager/taco/zed/keymap.nix`.
- `Alt-h/j/k/l`: `tmux` global pane movement; conflicts with any app in tmux wanting those keys because `bind -n` captures them first. Source: `nixos/shared-home-manager/taco/tmux/default.nix`.

## Constraints

- Do not claim a collision is definitive unless you checked the relevant upper layer.
- Do not equate cross-application reuse with a conflict if the apps do not run in the same input path.
- Prefer repository evidence first, runtime evidence second, upstream default docs third.
