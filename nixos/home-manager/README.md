# Home Manager Configuration

This directory contains Home Manager configurations that can be shared between different platforms (Linux, macOS/Darwin).

## Directory Structure

- `/home-manager/taco/`: Contains all the actual configuration modules for the user "taco"
- `/home-manager/platforms/linux/`: Platform-specific entry point for Linux systems
- `/home-manager/platforms/darwin/`: Platform-specific entry point for macOS/Darwin systems
- `/home-manager/default.nix`: Main entry point that can be used to import all configurations

## Usage

### For Linux

In your Linux NixOS configuration, you can import the Linux-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ../home-manager/platforms/linux
  ];
};
```

### For Darwin

In your Darwin configuration, you can import the Darwin-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ../home-manager/platforms/darwin
  ];
};
```

## Adding Shared Configuration

Configuration that should be shared between all platforms should be added to the appropriate module in the `taco/` directory.

Platform-specific configurations can be added to the respective platform directory.