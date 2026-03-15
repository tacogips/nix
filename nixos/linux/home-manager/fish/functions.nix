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

  codex-loop = ''
    set -l n $argv[1]

    if test -z "$n"
      echo "usage: codex-loop n [prompt]" >&2
      echo "   or: cat prompt.md | codex-loop n" >&2
      return 1
    end

    if not string match -qr '^[1-9][0-9]*$' -- $n
      echo "codex-loop: n must be a positive integer" >&2
      return 1
    end

    set -e argv[1]

    set -l prompt

    if test (count $argv) -gt 0
      set prompt (string join ' ' -- $argv)
    else if not isatty stdin
      set prompt (cat)
    else
      echo "usage: codex-loop n [prompt]" >&2
      echo "   or: cat prompt.md | codex-loop n" >&2
      return 1
    end

    set -l codex_loop_suffix "Check whether the current architecture/design matches this intended purpose. If it does not, update the design, create an implementation plan, and implement it. This work will be carried out over multiple iterations. If there is a git diff, review it and check whether there is any continuation of the previous task, any bugs, any overlooked considerations, or any areas that can be further improved, and fix them if necessary."
    set prompt "$prompt\n\n$codex_loop_suffix"

    for i in (seq $n)
      command codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.1-codex-max "$prompt"
    end
  '';
}
