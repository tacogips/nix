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

  rgl = ''
    rg --json $argv | delta
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

  bkms = ''
    set -l home_dir $HOME
    set -l bookmark_dir $home_dir/.private/bookmarks
    if test -d $bookmark_dir
      for file in $bookmark_dir/*
        if test -f $file
          set -l filename (path basename --no-extension $file)
          set -l content (cat $file)
          echo "bookmark_$filename $content"

        end
      end
    else
      echo "Error: Bookmark directory $bookmark_dir does not exist"
      return 1
    end
  '';

  hs = ''
    set -l cmd (history | ${pkgs.fzf}/bin/fzf --height 40% --layout reverse --info inline --border --tac)
    if test -n "$cmd"
      commandline -r $cmd
      commandline -f execute
    end
  '';

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

}