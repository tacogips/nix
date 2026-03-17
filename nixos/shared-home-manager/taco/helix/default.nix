{ pkgs, ... }:

let
  yaziPicker = pkgs.writeShellApplication {
    name = "hx-yazi-picker";
    runtimeInputs = with pkgs; [
      coreutils
      gnused
      yazi
      zellij
    ];
    text = ''
      set -euo pipefail

      tmp_file="$(mktemp -t yazi-chosen.XXXXXX)"

      cleanup() {
        rm -f -- "$tmp_file"
      }

      trap cleanup EXIT

      yazi --chooser-file="$tmp_file"

      if [[ -s "$tmp_file" ]]; then
        selected_path="$(head -n 1 -- "$tmp_file")"

        if [[ "$selected_path" == search://* ]]; then
          selected_path="$(printf '%s' "$selected_path" | sed 's|search://[^/]*/||')"
        fi

        selected_path="$(printf '%s' "$selected_path" | sed 's|\\|\\\\|g; s|"|\\"|g')"

        zellij action toggle-floating-panes
        zellij action write 27
        zellij action write-chars ":open \"$selected_path\""
        zellij action write 13
      else
        zellij action toggle-floating-panes
      fi
    '';
  };
in

{
  # Shared Helix configuration.
  # Only the subset of Zed's custom bindings with clear Helix equivalents is
  # ported here; panel-oriented and GUI-only bindings stay in Zed.
  # Language servers for Rust, Go, and TypeScript React are installed here so
  # Helix has the required binaries on both Linux and Darwin.
  home.packages = with pkgs; [
    gopls
    rust-analyzer
    nodePackages.typescript
    nodePackages.typescript-language-server
  ];

  programs.helix = {
    enable = true;

    settings = {
      keys = import ./keymap.nix {
        inherit yaziPicker;
        zellijBin = "${pkgs.zellij}/bin/zellij";
      };
    };

    languages = import ./languages.nix;
  };
}
