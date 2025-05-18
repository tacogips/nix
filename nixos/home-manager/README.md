# Home Manager Configuration

This directory contains Home Manager configurations that can be shared between different platforms (Linux, macOS/Darwin).

## Directory Structure

- `/home-manager/taco/`: Contains shared, platform-independent configuration modules for the user "taco"
- `/home-manager/platforms/linux/`: Linux-specific configuration
  - `home.nix`: Main configuration file for Linux
  - `default.nix`: Entry point that imports both Linux-specific and shared configurations
- `/home-manager/platforms/darwin/`: macOS/Darwin-specific configuration
  - Will follow similar structure to the Linux configuration
- `/home-manager/default.nix`: Root entry point (doesn't directly import anything)

## Usage

### For Linux

In your Linux NixOS configuration, import the Linux-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ../home-manager/platforms/linux
  ];
};
```

### For Darwin

In your Darwin configuration, import the Darwin-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ../home-manager/platforms/darwin
  ];
};
```

## Configuration Organization

- **Platform-Independent Configs**: Add to `taco/` directory modules
  - Examples: git, fish, bat, ssh configurations that work on any platform
- **Platform-Specific Configs**: Add to respective platform directories
  - Examples: Wayland, Hyprland (Linux-specific) or macOS-specific settings

This separation makes it easy to maintain consistent configurations across platforms while allowing for platform-specific customizations.