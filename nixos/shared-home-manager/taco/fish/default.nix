{ lib, pkgs, ... }:
let

  fishFunctions = import ./functions.nix { inherit pkgs; };
  fishAliases = import ./aliases.nix {
    inherit lib pkgs;
  };
  aliases = fishAliases.aliases;
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

      fish_vi_key_bindings
      bind -M insert ctrl-p up-or-search
      bind -M insert ctrl-n down-or-search

      bind -M insert ctrl-o accept-autosuggestion



      function __taco_fish_bind_mode_indicator
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

      function fish_mode_prompt
      end

      set -g fish_escape_delay_ms 10
      set -g __fish_git_prompt_show_informative_status true
      set -g __fish_git_prompt_showdirtystate true
      set -g __fish_git_prompt_showstagedstate true
      set -g __fish_git_prompt_showuntrackedfiles true
      set -g __fish_git_prompt_showupstream informative
      set -g __fish_git_prompt_showcolorhints true

      function fish_prompt
        set -l last_status $status

        __taco_fish_bind_mode_indicator

        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal

        set -l git_info (fish_git_prompt " (%s)")
        if test -n "$git_info"
          echo -n $git_info
        end

        if test $last_status -ne 0
          set_color red
          echo -n " [$last_status]"
          set_color normal
        end

        echo

        if fish_is_root_user
          echo -n '# '
        else
          echo -n '> '
        end
      end

      set -l exports_file "$HOME/.config/fish/exports.fish"
      if test -f $exports_file
           source $exports_file
      end

      if command -sq kinko
           kinko export fish --shared-only --force 2>/dev/null | source
      end

    '';
  };

  # exports.fish moved to Linux-specific configuration
}
