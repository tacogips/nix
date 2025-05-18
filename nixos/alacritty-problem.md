# Alacritty Configuration Issues with Fish Shell on macOS (nix-darwin)

## Current Problems

1. **Fish Shell Not Starting in Alacritty**
   - Fish shell works correctly in macOS Terminal.app
   - Fish shell doesn't start automatically in Alacritty
   - When using `chsh` to set fish as login shell, system reports it as "non-standard shell"

2. **Shell Path Resolution Issues**
   - Attempted path: `/run/current-system/sw/bin/fish` - not being recognized correctly
   - Current fish location: `/etc/profiles/per-user/taco/bin/fish` (from `which fish`)
   - Fish not present in standard `/etc/shells` file

## Attempted Solutions

### 1. Alacritty Configuration Changes
- Updated Alacritty configuration to specify fish shell with absolute path:
  ```nix
  # Set fish as the default shell - use absolute path to fish
  shell = {
    program = "/run/current-system/sw/bin/fish";
    args = ["-l"];
  };
  ```

- Tried using Nix store path:
  ```nix
  # Set fish as the default shell - use Nix store path
  shell = {
    program = "${pkgs.fish}/bin/fish";
    args = ["-l"];
  };
  ```

- Removed potentially problematic key bindings (Ctrl+H) that were causing issues

### 2. System-Level Shell Configuration
- Added fish to available shells:
  ```nix
  # Add fish to available shells
  environment.shells = [ pkgs.fish ];
  ```

- Set fish as default shell for user:
  ```nix
  # Set fish as default shell
  users.users.taco = {
    shell = pkgs.fish;
  };
  ```

- Enabled fish in darwin configuration:
  ```nix
  programs.fish.enable = true;
  ```

### 3. Custom /etc/shells Configuration
- Attempted to create a custom `/etc/shells` file to register fish as valid shell:
  ```nix
  # Add shell to /etc/shells
  environment.etc."shells".text = ''
    # List of acceptable shells for chpass(1).
    # Ftpd will not allow users to connect who are not using
    # one of these shells.
    
    /bin/bash
    /bin/csh
    /bin/dash
    /bin/ksh
    /bin/sh
    /bin/tcsh
    /bin/zsh
    ${pkgs.fish}/bin/fish
  '';
  ```

### 4. Home Manager Fish Configuration
- Added explicit fish configuration in home-manager:
  ```nix
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting
    '';
  };
  ```

## Possible Issues and Next Steps

1. **Path Resolution**
   - The path to fish in nix-darwin might differ from standard paths
   - Need to ensure the path in Alacritty configuration matches the actual path of installed fish
   - Consider using a shell script wrapper if path resolution continues to be problematic

2. **Shell Registration**
   - Need to verify if fish is correctly registered as a valid login shell
   - May need to use a different approach to register fish in `/etc/shells`
   - Consider investigating how nix-darwin typically handles shell registration

3. **Alacritty Execution Flow**
   - Investigate how Alacritty determines which shell to start on macOS
   - May need to examine if there are environment variables influencing shell selection

4. **Potential Next Steps**
   - Try using the fully resolved Nix store path (from `readlink -f $(which fish)`) in Alacritty config
   - Consider temporarily using a shell script wrapper that calls fish
   - Investigate logs or debug output from Alacritty to see which shell it's attempting to launch
   - Consider asking for specific nix-darwin examples of properly configured Alacritty+fish combinations
   - Explore if there are macOS-specific shell initialization issues affecting Alacritty

## References
- Current fish location: `/etc/profiles/per-user/taco/bin/fish`
- Standard shells in `/etc/shells`: bash, csh, dash, ksh, sh, tcsh, zsh
- Alacritty config location: `/Users/taco/nix/nixos/darwin/home-manager/alacritty.nix`
- System configuration location: `/Users/taco/nix/nixos/darwin/configuration.nix`