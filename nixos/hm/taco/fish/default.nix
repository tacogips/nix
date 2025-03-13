{ pkgs, ... }:
let

  fishFunctions = import ./functions.nix { inherit pkgs; };
  aliases = import ./aliases.nix;
  abbrs = import ./abbrs.nix;
in
{
  programs.fish = {
    enable = true;
    shellAliases = aliases;

    shellAbbrs = abbrs;

    functions = fishFunctions;

    interactiveShellInit = ''

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_visual underscore
      set fish_cursor_replace_one underscore

      function fish_user_key_bindings
          # Execute this once per mode that emacs bindings should be used in
          fish_default_key_bindings -M insert
          fish_vi_key_bindings --no-erase insert
      end


      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            set_color --bold red
            echo '[N] '
          case insert
            set_color --bold green
            echo '[I] '
          case replace_one
            set_color --bold green
            echo '[R] '
          case visual
            set_color --bold magenta
            echo '[V] '
        end
        set_color normal
      end

      set -g fish_escape_delay_ms 10

      if test -f "$HOME/.private/fish/private.fish"
            source $credentials_file
      end

      if test -f "$HOME/.config/fish/export.fish"
           source $export_file
      end
    '';
  };

  home.file.".config/fish/export.fish" = {
    source = ./export.fish;
  };

}
