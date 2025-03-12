{ pkgs, ... }:
{

  programs.fish = {
    enable = true;
    functions = {
      gs = "git status";

    };

    shellAbbrs = {
      z = "zeditor";
      lg = "lazygit";
    };

    interactiveShellInit = ''
      fish_vi_key_bindings

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_visual underscore
      set fish_cursor_replace_one underscore

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
    '';

  };

}
