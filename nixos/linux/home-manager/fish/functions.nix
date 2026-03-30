{ pkgs, ... }:
let
  agentCommands = import ../../../shared-home-manager/taco/fish/agent-commands.nix { };
  codexExecCommand = "${agentCommands.codexBaseCommand} exec";
  inherit (agentCommands)
    agentLoopSuffix
    codexReviewTodayPrompt
    cursorPrintCommand
    ;
in
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

  __agent-loop-print-usage = ''
    set -l loop_name $argv[1]
    set -l prompt_mode $argv[2]

    switch $prompt_mode
      case input
        echo "usage: $loop_name n [prompt]" >&2
        echo "   or: cat prompt.md | $loop_name n" >&2
      case fixed
        echo "usage: $loop_name n" >&2
    end
  '';

  __agent-loop-run = ''
    set -l loop_name $argv[1]
    set -l runner $argv[2]
    set -l prompt_mode $argv[3]
    set -l fixed_prompt

    switch $prompt_mode
      case fixed
        set fixed_prompt $argv[4]
        set argv $argv[5..-1]
      case '*'
        set argv $argv[4..-1]
    end

    set -l n $argv[1]
    if test -z "$n"
      __agent-loop-print-usage $loop_name $prompt_mode
      return 1
    end

    if not string match -qr '^[1-9][0-9]*$' -- $n
      echo "$loop_name: n must be a positive integer" >&2
      return 1
    end

    set argv $argv[2..-1]
    set -l prompt

    switch $prompt_mode
      case input
        if test (count $argv) -gt 0
          set prompt (string join ' ' -- $argv)
        else if not isatty stdin
          set prompt (cat | string collect)
        else
          __agent-loop-print-usage $loop_name $prompt_mode
          return 1
        end
      case fixed
        if test (count $argv) -ne 0
          __agent-loop-print-usage $loop_name $prompt_mode
          return 1
        end
        set prompt $fixed_prompt
      case '*'
        echo "$loop_name: unsupported prompt mode: $prompt_mode" >&2
        return 1
    end

    set prompt (printf '%s\n\n%s' "$prompt" "${agentLoopSuffix}" | string collect)

    for i in (seq $n)
      switch $runner
        case codex
          command ${codexExecCommand} "$prompt"
        case cursor
          command ${cursorPrintCommand} "$prompt"
        case '*'
          echo "$loop_name: unsupported runner: $runner" >&2
          return 1
      end
    end
  '';

  codex-loop = ''
    __agent-loop-run codex-loop codex input $argv
  '';

  codex-loop-review-today = ''
    __agent-loop-run codex-loop-review-today codex fixed "${codexReviewTodayPrompt}" $argv
  '';

  cursor-loop = ''
    __agent-loop-run cursor-loop cursor input $argv
  '';

  cursor-loop-review-today = ''
    __agent-loop-run cursor-loop-review-today cursor fixed "${codexReviewTodayPrompt}" $argv
  '';
}
