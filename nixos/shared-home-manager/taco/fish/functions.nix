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

  setup-claude-mcps-global = ''
    ${pkgs.claude-code}/bin/claude mcp add -s user bravesearch-mcp bravesearch-mcp stdio
    and ${pkgs.claude-code}/bin/claude mcp add -s user gitcodes-mcp gitcodes-mcp stdio
    and ${pkgs.claude-code}/bin/claude mcp add -s user cratedocs-mcp cratedocs-mcp stdio
  '';

  setup-claude-cratedocs-mcp-local = ''
    ${pkgs.claude-code}/bin/claude mcp add -s local cratedocs-mcp cratedocs-mcp stdio
  '';

  remove-claude-cratedocs-mcp-local = ''
    ${pkgs.claude-code}/bin/claude mcp remove -s local cratedocs-mcp
  '';

  gh-pr-view = ''
    ${pkgs.gh}/bin/gh pr view --web
  '';

  gh-token-export = ''
    set -l token (${pkgs.gh}/bin/gh auth token 2>/dev/null)
    if test -z "$token"
      echo "Error: Failed to get GitHub token. Please run 'gh auth login' first."
      return 1
    end

    set -l private_fish_dir "$HOME/.private/fish"
    set -l private_fish_file "$private_fish_dir/private.fish"

    # Create directory if it doesn't exist
    if not test -d $private_fish_dir
      mkdir -p $private_fish_dir
    end

    # Check if file exists and has GITHUB_TOKEN line
    if test -f $private_fish_file
      if ${pkgs.gnugrep}/bin/grep -q "^set -x GITHUB_TOKEN" $private_fish_file
        # Extract existing token and compare
        set -l existing_token (${pkgs.gnugrep}/bin/grep "^set -x GITHUB_TOKEN" $private_fish_file | ${pkgs.gnused}/bin/sed 's/^set -x GITHUB_TOKEN //')
        if test "$existing_token" = "$token"
          echo "GITHUB_TOKEN is already up to date"
        else
          # Update existing GITHUB_TOKEN line
          ${pkgs.gnused}/bin/sed -i "s|^set -x GITHUB_TOKEN.*|set -x GITHUB_TOKEN $token|" $private_fish_file
          echo "Updated GITHUB_TOKEN in $private_fish_file"
        end
      else
        # Append GITHUB_TOKEN line
        echo "set -x GITHUB_TOKEN $token" >> $private_fish_file
        echo "Added GITHUB_TOKEN to $private_fish_file"
      end
    else
      # Create new file with GITHUB_TOKEN
      echo "set -x GITHUB_TOKEN $token" > $private_fish_file
      echo "Created $private_fish_file with GITHUB_TOKEN"
    end

    # Also export to current session
    set -gx GITHUB_TOKEN $token
    echo "GITHUB_TOKEN exported to current session"
  '';

}
