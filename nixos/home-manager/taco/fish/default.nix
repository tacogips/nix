{ pkgs, ... }:
let

  fishFunctions = import ./functions.nix { inherit pkgs; };
  aliases = import ./aliases.nix { inherit pkgs; };
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

      set -l credential_file "$HOME/.private/fish/private.fish"
      if test -f $credential_file
        source $credential_file
      end

      set -l exports_file "$HOME/.config/fish/exports.fish"
      if test -f $exports_file
           source $exports_file
      end
    '';
  };

  home.file.".config/fish/exports.fish" = {
    source = ./exports.fish;
  };

  home.file.".private/fish/private.example.fish" = {
    text = ''
      set -x ANTHROPIC_API_KEY xxxx
      set -x EXA_API_KEY  xxxx
      set -x GEMINI_API_KEY xxxx
      set -x BRAVE_API_KEY  xxxx
      set -x OPENAI_API_KEY xxxxx
    '';
  };

}
