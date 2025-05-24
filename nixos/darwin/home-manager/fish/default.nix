{ pkgs, lib, config, ... }:

let
  darwinFishFunctions = import ./functions.nix { inherit pkgs; };
  darwinFishAliases = import ./aliases.nix { inherit pkgs; };
in
{
  # Set Darwin-specific fish functions and aliases
  programs.fish = {
    functions = lib.mkForce darwinFishFunctions;
    shellAliases = lib.mkForce darwinFishAliases;
    
    # Darwin-specific fish settings
    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting
      
      # Darwin-specific fish settings
      set -gx PATH $HOME/.local/bin $PATH
      
      # Darwin-specific key bindings
      bind -M insert ctrl-h backward-delete-char
      bind -M insert ctrl-a beginning-of-line
    '';
  };
}