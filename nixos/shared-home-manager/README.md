# Home Manager Configuration

This directory contains only shared, platform-independent Home Manager configurations that can be used by both Linux and macOS/Darwin.

## Directory Structure

- `/home-manager/taco/`: Contains shared, platform-independent configuration modules for the user "taco"
- `/home-manager/default.nix`: Root entry point (doesn't directly import anything)

The platform-specific configurations are located in their respective OS directories:
- `/linux/home-manager/`: Linux-specific Home Manager configuration
- `/darwin/home-manager/`: Darwin-specific Home Manager configuration

## Usage

### For Linux

In your Linux NixOS configuration, import the Linux-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ./home-manager
  ];
};
```

### For Darwin

In your Darwin configuration, import the Darwin-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ./home-manager
  ];
};
```

## Configuration Organization

- **Platform-Independent Configs**: Add to `home-manager/taco/` directory modules
  - Examples: git, fish, bat, ssh, ghostty, helix, yazi, and zellij configurations that work on any platform
- **Platform-Specific Configs**: Add to the respective OS directories
  - Linux-specific configs: `linux/home-manager/`
  - Darwin-specific configs: `darwin/home-manager/`

This separation makes it easy to maintain consistent configurations across platforms while allowing for platform-specific customizations in their appropriate locations.

The shared editor environment now follows the Zellij + Helix + Yazi workflow. The shared modules define the Helix/Yazi/Zellij integration, while the platform-specific Home Manager entrypoints set `taco.yazi.openCommand` so Yazi can hand files off to the correct GUI opener on Linux and Darwin. Yazi now routes PDF, image, and video files to `chilla`, while directories still open in a terminal and other file types continue to use the platform GUI opener. In the shared Yazi config, pressing `Enter` on a directory exits Yazi into that directory in the current terminal instead of handing it to the GUI file opener. When Yazi is launched from fish as `yazi` or `y`, exiting Yazi updates the current shell to the last directory you visited.

Rust editor integrations keep `cargo check` artifacts under `target/ra` and place rust-analyzer's own target data under `target/rust-analyzer` so background analysis does not contend with the save-time diagnostics output.

The shared Zellij module provides two launch styles:
- `ide`: a two-pane workspace with Yazi on the left and Helix on the right; opening a file in Yazi loads it into the adjacent Helix pane
- `ide-agent 3|4|5`: an agent-coding workspace that opens a project with 3, 4, or 5 side-by-side terminal panes

The shared tmux workflow now exposes predefined layouts directly inside tmux. `Alt-t` opens a new window and immediately shows a layout menu, while `Alt-i` still opens a plain new window rooted at the current pane's directory. `prefix + I` shows the same menu for the current window and rebuilds the window from the active pane before applying the selected layout. `Alt-z` enters a temporary resize mode where `h/j/k/l` resize the active pane until you press `Esc` or `Enter`. The `ide-3pane` layout starts Yazi on the left, opens files in Helix in the center pane, and retargets directory selections to the right pane's current working directory.
