# System Prompt for AI Assistants Working on This Nix Flake Project

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input. Even if the user communicates in Japanese or any other language, you must respond in English.

You (the LLM model) must acknowledge that you have read CLAUDE.md and will comply with its contents in your first response.

## Directory Structure Policy

### Overall Structure

- `nixos/` - Root directory
  - `linux/` - Linux-specific system configuration
  - `darwin/` - macOS-specific system configuration
  - `shared-home-manager/` - Shared, platform-independent Home Manager modules

### Platform-Specific vs. Shared Configuration

- Keep platform-independent configurations in `nixos/shared-home-manager/`
- Store platform-specific configurations in their respective OS directories:
  - Linux-specific: `nixos/linux/home-manager/`
  - Darwin-specific: `nixos/darwin/home-manager/`

### Home Manager Structure

- `nixos/shared-home-manager/taco/` - Contains shared user modules that work across platforms
- `nixos/linux/home-manager/` - Linux-specific Home Manager configuration
  - Imports shared modules from `nixos/shared-home-manager/taco/`
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

- After making changes, rebuild with: `nixos-rebuild switch --flake .#nix-dev-machine`
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

## Developer Notes

### Adding New Home Manager Packages

#### For Cross-Platform Packages

1. Create a new module in the shared directory:

   ```
   mkdir -p nixos/shared-home-manager/taco/new-package
   touch nixos/shared-home-manager/taco/new-package/default.nix
   ```

2. Write your configuration in `default.nix`:

   ```nix
   { config, pkgs, ... }:

   {
     programs.new-package = {
       enable = true;
       # Add package-specific configuration
     };
   }
   ```

3. Add the module to the shared imports in `nixos/shared-home-manager/taco/default.nix`:

   ```nix
   imports = [
     # Existing imports...
     ./new-package
   ];
   ```

4. The package will automatically be available on both Linux and Darwin systems that import the shared modules.

#### For Platform-Specific Packages

1. For Linux-only packages, create a module in:

   ```
   nixos/linux/home-manager/specific-package/default.nix
   ```

2. For Darwin-only packages, create a module in:

   ```
   nixos/darwin/home-manager/specific-package/default.nix
   ```

3. Import the platform-specific module in the respective platform's configuration.

#### Handling Configuration Conflicts

When a shared module has settings that conflict with platform-specific needs:

1. Use `lib.mkForce` to override conflicting settings:

   ```nix
   programs.git = {
     userName = lib.mkForce "platform-specific-username";
     userEmail = lib.mkForce "platform-specific@email.com";
   };
   ```

2. For more complex overrides, consider creating platform-specific extensions of shared modules.

#### Testing New Packages

1. Add the package to the appropriate configuration
2. Commit the changes (flakes only track files in git)
3. Run platform-specific rebuild command:
   - Linux: `nixos-rebuild switch --flake .#nix-dev-machine`
   - Darwin: `darwin-rebuild switch --flake .#taco-mac`

#### Tips for Package Compatibility

- Check package availability on both platforms using `nix search nixpkgs#package-name`
- Some packages may need different configuration options on different platforms
- When evaluating fails, try applying configuration with `--show-trace` flag for more detailed error information
- Use the Home Manager manual to check for platform-specific options and limitations
