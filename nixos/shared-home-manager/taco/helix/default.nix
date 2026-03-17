{ ... }:

{
  # Shared Helix configuration.
  # Only the subset of Zed's custom bindings with clear Helix equivalents is
  # ported here; panel-oriented and GUI-only bindings stay in Zed.
  programs.helix = {
    enable = true;

    settings = {
      keys = import ./keymap.nix;
    };
  };
}
