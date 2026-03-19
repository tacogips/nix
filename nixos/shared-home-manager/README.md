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

The shared editor environment now follows the Zellij + Helix + Yazi workflow. The shared modules define the Helix/Yazi/Zellij integration, while the platform-specific Home Manager entrypoints set `taco.yazi.openCommand` so Yazi can hand files off to the correct GUI opener on Linux and Darwin. In the shared Yazi config, opening a directory launches a new terminal rooted at that directory instead of handing it to the GUI file opener. When Yazi is launched from fish as `yazi` or `y`, exiting Yazi updates the current shell to the last directory you visited.

The shared Zellij module provides two launch styles:
- `ide`: a two-pane workspace with Yazi on the left and Helix on the right; opening a file in Yazi loads it into the adjacent Helix pane
- `ide-agent 3|4|5`: an agent-coding workspace that opens a project with 3, 4, or 5 side-by-side terminal panes

The shared tmux workflow exposes a `tm` fish function that opens a fresh three-pane workspace. The left pane starts Yazi, file selections open in Helix in the center pane, and directory selections retarget the right pane's current working directory. Plain `tmux` remains unmodified.
