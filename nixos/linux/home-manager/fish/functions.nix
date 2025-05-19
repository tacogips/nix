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
}