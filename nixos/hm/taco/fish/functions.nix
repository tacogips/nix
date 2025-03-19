{ pkgs, ... }:
{
  fdd = ''
    set dest (${pkgs.fd}/bin/fd --type directory | ${pkgs.fzf}/bin/fzf +m --query "$argv")
    if test -n "$dest"
        cd "$dest"
    end
  '';

  ff = ''
    set dest (${pkgs.fd}/bin/fd --color=never $argv[1] | ${pkgs.fzf}/bin/fzf +m --query "$LBUFFER" --prompt="find > ")
    if test -n "$dest"
        ${pkgs.zed-editor}/bin/zeditor "$dest"
    end
  '';

  rgg = ''
    set dest (${pkgs.ripgrep}/bin/rg --line-number --no-heading --color=never $argv[1] | ${pkgs.fzf}/bin/fzf +m --query "$LBUFFER" --prompt="rg > ")
    if test -n "$dest"
        set line_number (echo $dest | cut -d: -f2)
        set file_path (echo $dest | cut -d: -f1)
        ${pkgs.zed-editor}/bin/zeditor  $file_path:$line_number
    end
  '';

  y = ''
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    ${pkgs.yazi}/bin/yazi $argv --cwd-file="$tmp"
    if test -s "$tmp"
        set cwd (cat -- "$tmp")
        if test -n "$cwd" -a "$cwd" != "$PWD"
            cd "$cwd"
        end
    end
    rm -f -- "$tmp"
  '';

  fd = ''
    set -l selected_dir (${pkgs.zoxide}/bin/zoxide query --list --score | ${pkgs.fzf}/bin/fzf --height 40% --layout reverse --info inline --border --preview "${pkgs.eza}/bin/eza --all --group-directories-first --header --long --no-user --no-permissions --color=always {2}" --no-sort | ${pkgs.gawk}/bin/awk '{print $2}')
    if test -n "$selected_dir"
        cd $selected_dir
    end
  '';

  capture_active = ''
    set -l timestamp (date +%Y-%m-%d-%H%M%S)
    set -l img_path  ~/Pictures/capture_active_$timestamp.png
    ${pkgs.hyprland}/bin/hyprctl -j activewindow | ${pkgs.jq}/bin/jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${pkgs.grim}/bin/grim -g - $img_path
    wl-copy < $img_path
  '';

  capture_sel = ''
    set -l timestamp (date +%Y-%m-%d-%H%M%S)
    set -l img_path  ~/Pictures/capture_sel_$timestamp.png
    ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - $img_path
    wl-copy < $img_path
  '';

}
