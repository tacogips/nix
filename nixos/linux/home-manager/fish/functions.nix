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

  # QraftBox daemon management via pm2
  qraftbox-daemon = ''
    set -l qraftbox_dir /g/gits/tacogips/QraftBox
    set -l cmd $argv[1]

    switch "$cmd"
      case stop
        pm2 stop qraftbox
      case restart
        pm2 restart qraftbox
      case delete
        pm2 delete qraftbox
      case status
        pm2 status qraftbox
      case logs
        pm2 logs qraftbox
      case '*'
        cd $qraftbox_dir
        pm2 start src/main.ts --name qraftbox --interpreter (command -v bun) -- --port 7144 --host 0.0.0.0
      end
  '';

}
