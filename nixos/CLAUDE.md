# System Prompt for AI Assistants Working on This Nix Flake Project

## Directory Structure Policy

### Overall Structure
- `nixos/` - Root directory
  - `linux/` - Linux-specific system configuration
  - `darwin/` - macOS-specific system configuration
  - `home-manager/` - Shared, platform-independent Home Manager modules

### Platform-Specific vs. Shared Configuration
- Keep platform-independent configurations in `nixos/home-manager/`
- Store platform-specific configurations in their respective OS directories:
  - Linux-specific: `nixos/linux/home-manager/`
  - Darwin-specific: `nixos/darwin/home-manager/`

### Home Manager Structure
- `nixos/home-manager/taco/` - Contains shared user modules that work across platforms
- `nixos/linux/home-manager/` - Linux-specific Home Manager configuration
  - Imports shared modules from `nixos/home-manager/taco/`
  - Contains Linux-specific settings and imports
- `nixos/darwin/home-manager/` - Darwin-specific Home Manager configuration

## Important Nix Command Considerations

### Git Tracking Requirement
- **Critical**: Nix flakes only recognize files tracked by Git
- Always commit new files before running `nix flake check` or other flake commands
- Untracked files will cause "file not found" errors even if they exist on disk

### Path Resolution
- Relative paths in flake.nix are resolved from the flake's root, not the file's location
- Be careful with import paths - prefer paths relative to the flake root
- When in doubt, use `../` to navigate from the current flake directory

### Rebuilding the System
- After making changes, rebuild with: `nixos-rebuild switch --flake .#taco-main`
  - Run from the `nixos/linux` directory
- For macOS/Darwin systems, use: `darwin-rebuild switch --flake .#taco-mac`
  - Run from the `nixos/darwin` directory
  - May require sudo: `sudo ./result/sw/bin/darwin-rebuild switch --flake .#taco-mac`

### Diagnostics
- Common deprecation warnings can be safely ignored for now
- Use `nix flake check` to verify configuration before applying changes

## Best Practices

### Modularity
- Keep related functionality in self-contained modules
- Prefer creating new modules over modifying existing ones
- Platform-specific settings should only be defined in platform-specific directories

### Cross-Platform Configuration
- When adding new software, consider if it's platform-specific or could be shared
- User identity settings (`home.username`, `home.homeDirectory`) should be defined in platform-specific configs
- Global settings like `home.stateVersion` can be shared across platforms

### Documentation
- Update README files when changing directory structures
- Document platform-specific requirements or dependencies

## Darwin (macOS) Configuration

### Flake Structure
- Darwin flakes follow the same general structure as Linux flakes
- Use `darwin.lib.darwinSystem` instead of `nixpkgs.lib.nixosSystem`
- Darwin configurations use different module options than NixOS

### Home Manager Integration
- Use `home-manager.darwinModules.home-manager` for macOS
- When importing shared modules, be aware of potential conflicts:
  - Use `lib.mkForce` to override conflicting definitions like `home.username` and `home.homeDirectory`
  - Example: `home.homeDirectory = mkForce "/Users/username";`

### Common Darwin-Specific Options
- System defaults are set via `system.defaults.NSGlobalDomain`
- Set the primary user with `system.primaryUser = "username";`
- Enable shells with `programs.fish.enable = true;`
- Set default shell in `users.users.username.shell = pkgs.fish;`

### Migration Notes for Darwin
- Font configuration has changed:
  - Old: `fonts.fontDir.enable = true;`
  - New: `fonts.packages = with pkgs; [ font1 font2 ];`
- Nix daemon configuration has changed:
  - Old: `services.nix-daemon.enable = true;`
  - New: `nix.enable = true;`
- NerdFonts structure has updated:
  - Old: `nerdfonts.override { fonts = [ "JetBrainsMono" ]; }`
  - New: `nerd-fonts.jetbrains-mono`

### Applying Darwin Configuration
- Build first: `nix build .#darwinConfigurations.taco-mac.system`
- Apply: `./result/sw/bin/darwin-rebuild switch --flake .#taco-mac`
- Sudo may be required for the first application