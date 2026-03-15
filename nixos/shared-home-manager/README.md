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
  - Examples: git, fish, bat, ssh configurations that work on any platform
- **Platform-Specific Configs**: Add to the respective OS directories
  - Linux-specific configs: `linux/home-manager/`
  - Darwin-specific configs: `darwin/home-manager/`

This separation makes it easy to maintain consistent configurations across platforms while allowing for platform-specific customizations in their appropriate locations.