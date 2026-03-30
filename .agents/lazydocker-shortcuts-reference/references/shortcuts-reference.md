# Lazydocker Shortcuts Reference

Use this file for compact Lazydocker answers.

## Repo-local override status

Source: `nixos/shared-home-manager/taco/lazydocker/default.nix`

- Theme colors are customized.
- No repo-local shortcut overrides are defined.

## Common default shortcuts

Installed locally in this environment:

- `lazydocker 0.25.0`

Global:

- `1` to `6`: focus panels `project`, `services`, `containers`, `images`, `volumes`, `networks`
- `+` / `_`: next / previous screen mode

Shared list-panel keys:

- `enter`: focus main panel
- `[` / `]`: previous / next tab
- `/`: filter current list

Project panel:

- `e`: edit config
- `o`: open config
- `m`: view logs

Containers panel:

- `d`: remove
- `e`: hide/show stopped containers
- `p`: pause
- `s`: stop
- `r`: restart
- `a`: attach
- `m`: view logs
- `E`: exec shell
- `c`: run predefined custom command
- `b`: bulk commands
- `w`: open first exposed HTTP port in browser

Services panel:

- `u`: up service
- `d`: remove containers
- `s`: stop
- `p`: pause
- `r`: restart
- `S`: start
- `a`: attach
- `m`: view logs
- `U`: up project
- `D`: down project
- `R`: restart options
- `c`: run predefined custom command
- `b`: bulk commands
- `E`: exec shell
- `w`: open first exposed HTTP port in browser

Images, volumes, networks:

- `c`: run predefined custom command
- `d`: remove selected item
- `b`: bulk commands

Main panel:

- `esc`: return

## Upstream references

- Lazydocker README: https://github.com/jesseduffield/lazydocker
- Official keybinding sheet: https://raw.githubusercontent.com/jesseduffield/lazydocker/master/docs/keybindings/Keybindings_en.md

## Answering guidance

- Start with "this repo adds no Lazydocker keybindings; defaults apply".
- If the user asks about one key, answer with panel context because Lazydocker bindings are panel-specific.
- If runtime config was not inspected, say the answer is based on repo source plus upstream defaults.
