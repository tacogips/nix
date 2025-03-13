{ pkgs, ... }:
let
  aliases = import ./aliases.nix;
  abbrs = import ./abbrs.nix;
in
{
  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellAbbrs = abbrs;

    interactiveShellInit = ''
      fish_vi_key_bindings

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_visual underscore
      set fish_cursor_replace_one underscore

      bind -M normal \cp up-or-search
      bind -M normal \cn down-or-search

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

      # Load credentials if the file exists
      set -l credentials_file "$HOME/.config/fish/credentials_private.fish"
      if test -f $credentials_file
            source $credentials_file
      end
    '';

  };
}
