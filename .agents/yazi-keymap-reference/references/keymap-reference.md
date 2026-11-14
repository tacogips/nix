# Yazi Keymap Reference

Use this file for compact, high-signal Yazi answers. It is not a full dump of the shipped keymap.

## Repo-local overrides

Source: `nixos/shared-home-manager/taco/yazi/keymap.nix`

- `<Enter>`: enter directory in the terminal or open file via `enter-directory`
- `, g`: show files and directories included in `git diff`
- `, r`: content search via ripgrep (`search --via=rg`)

## Common shipped defaults

Installed locally in this environment:

- `Yazi 26.1.22`

Common manager keys:

- `j` / `k`: move down/up
- `h` / `l`: leave/enter directory
- `H` / `L`: back/forward directory history
- `v` / `V`: visual select / unset visual mode
- `o` / `O`: open / interactive open
- `y` / `x`: yank copy / yank cut
- `p` / `P`: paste / force paste
- `d` / `D`: trash / permanently delete
- `a`: create file or directory
- `r`: rename
- `.`: toggle hidden files
- `;` / `:`: interactive shell / blocking shell

Search and find:

- `s`: filename search via `fd`
- `S`: content search via `rg`
- `<C-s>`: cancel ongoing search
- `f`: filter files
- `/`: find next in the current list
- `?`: find previous in the current list
- `n` / `N`: next / previous found item

Tabs and misc:

- `t`: create tab with current directory
- `[` / `]`: previous / next tab
- `{` / `}`: swap tabs
- `w`: task manager
- `~`: help
- `<Esc>`: cancel search, selection, visual mode, or related transient state

## Upstream references

- Yazi keymap docs: https://yazi-rs.github.io/docs/configuration/keymap/
- Shipped default keymap: https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml

## Answering guidance

- For "grep" questions, answer with `, r` first for this repo, then `S` as the shipped default.
- For exhaustive inventories, summarize by category and point to the shipped default keymap instead of reproducing the whole file.
- If asked what actually happens on `Enter`, mention the repo's `enter-directory` plugin rather than the upstream default open behavior.
