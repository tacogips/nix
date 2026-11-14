{
  config,
  lib,
  pkgs,
  ...
}:

let
  launchHerdr = pkgs.writeShellScript "ghostty-launch-herdr" ''
    for herdr in /opt/homebrew/bin/herdr /usr/local/bin/herdr; do
      if [ -x "$herdr" ]; then
        exec "$herdr"
      fi
    done

    echo "Herdr is not installed; starting a login shell instead." >&2
    exec ${pkgs.fish}/bin/fish --login
  '';
in
{
  taco.ghostty.startupCommand = "${launchHerdr}";

  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [terminal]
    default_shell = "${pkgs.fish}/bin/fish"
    shell_mode = "login"
    new_cwd = "follow"

    [keys]
    new_workspace = "alt+t"
    previous_workspace = "alt+k"
    next_workspace = "alt+j"
    rename_tab = "alt+r"
    switch_tab = "alt+1..9"
    zoom = "alt+f"
  '';

  # Retire the standalone tmux title updater and its launchd registration.
  home.activation.removeLegacyTmuxLaunchAgent = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    tmux_agent="$HOME/Library/LaunchAgents/com.taco.tmux-window-title.plist"

    if [ -e "$tmux_agent" ]; then
      $DRY_RUN_CMD /bin/launchctl bootout "gui/$UID" "$tmux_agent" 2>/dev/null || true
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm -f "$tmux_agent"
    fi
  '';
}
