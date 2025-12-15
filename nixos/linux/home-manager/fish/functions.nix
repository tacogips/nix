{ pkgs, ... }:
{
  capture_active = ''
    set -l timestamp (date +%Y-%m-%d-%H%M%S)
    set -l img_path  ~/Pictures/capture_active_$timestamp.png
    ${pkgs.hyprland}/bin/hyprctl -j activewindow | ${pkgs.jq}/bin/jq -r '"\.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${pkgs.grim}/bin/grim -g - $img_path
    wl-copy < $img_path
  '';

  capture_sel = ''
    set -l timestamp (date +%Y-%m-%d-%H%M%S)
    set -l img_path  ~/Pictures/capture_sel_$timestamp.png
    ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - $img_path
    wl-copy < $img_path
  '';

  capture_sel_video = ''
    set -l timestamp (date +%Y-%m-%d-%H%M%S)
    set -l video_path  ~/Pictures/capture_sel_video_$timestamp.mp4
    ${pkgs.wf-recorder}/bin/wf-recorder -g "$(${pkgs.slurp}/bin/slurp)" -f $video_path
  '';
  
  # NixOS-specific function to compare current and booted system packages
  nix_diff = ''
    set -l temp_dir (${pkgs.coreutils}/bin/mktemp -d -t "nix_diff_XXXXXX")
    echo "Comparing Nix store references..."
    echo "Creating current system reference list..."
    ${pkgs.nix}/bin/nix-store --query --references /run/current-system | ${pkgs.coreutils}/bin/sort > $temp_dir/current-nix.txt
    echo "Creating previous system reference list..."
    ${pkgs.nix}/bin/nix-store --query --references /run/booted-system | ${pkgs.coreutils}/bin/sort > $temp_dir/previous-nix.txt
    echo "Comparing differences with delta..."
    ${pkgs.delta}/bin/delta $temp_dir/previous-nix.txt $temp_dir/current-nix.txt
    # Clean up the temporary directory
    ${pkgs.coreutils}/bin/rm -rf $temp_dir
  '';

  # GitHub authentication setup function
  gh-auth-setup = ''
    set -x GIT_CONFIG_GLOBAL ~/.private/git/credential/config
    gh auth setup-git
  '';

  # GitHub authentication refresh function
  gh-auth-refresh = ''
    # Logout from GitHub CLI
    gh auth logout

    # Login to GitHub CLI
    gh auth login

    # Setup git credential helper to writable config
    set -x GIT_CONFIG_GLOBAL ~/.private/git/credential/config
    gh auth setup-git
  '';
}