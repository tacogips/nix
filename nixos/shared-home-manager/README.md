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
  - Examples: git, fish, bat, ssh, helix, yazi, and zellij configurations that work on any platform
- **Platform-Specific Configs**: Add to the respective OS directories
  - Linux-specific configs: `linux/home-manager/`
  - Darwin-specific configs: `darwin/home-manager/`

This separation makes it easy to maintain consistent configurations across platforms while allowing for platform-specific customizations in their appropriate locations.

The shared editor environment now follows the Zellij + Helix + Yazi workflow. The shared modules define the Helix/Yazi/Zellij integration, while the platform-specific Home Manager entrypoints set `taco.yazi.openCommand` so Yazi can hand files off to the correct GUI opener on Linux and Darwin.

The shared Zellij module provides two launch styles:
- `ide`: the default article-style development workspace
- `ide-agent 3|4|5`: an agent-coding workspace that opens a project with 3, 4, or 5 side-by-side terminal panes
