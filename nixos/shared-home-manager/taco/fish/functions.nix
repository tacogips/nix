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
        zed "$dest"
    end
  '';

  rgg = ''
    set dest (${pkgs.ripgrep}/bin/rg --line-number --no-heading --color=never $argv[1] | ${pkgs.fzf}/bin/fzf +m --query "$LBUFFER" --prompt="rg > ")
    if test -n "$dest"
        set line_number (echo $dest | cut -d: -f2)
        set file_path (echo $dest | cut -d: -f1)
        zed $file_path:$line_number
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
    claude mcp add -s user bravesearch-mcp bravesearch-mcp stdio
    and claude mcp add -s user hn-mcp hn-mcp stdio
  '';

  ppp = ''
    # Copy current directory to clipboard
    # On Darwin, use pbcopy; on Linux, use wl-copy
    if type -q pbcopy
        pwd | pbcopy
    else if type -q wl-copy
        pwd | wl-copy
    end
  '';

  cdp = ''
    # cd to path from clipboard
    # On Darwin, use pbpaste; on Linux, use wl-paste
    if type -q pbpaste
        cd (pbpaste)
    else if type -q wl-paste
        cd (wl-paste -n)
    end
  '';

  gh-pr-view = ''
    ${pkgs.gh}/bin/gh pr view --web
  '';

  gh-token-refresh = ''
    # Save old token for comparison
    set -l old_token (${pkgs.gh}/bin/gh auth token 2>/dev/null)

    # Logout to revoke current token
    echo "Revoking current GitHub token..."
    ${pkgs.gh}/bin/gh auth logout -h github.com 2>/dev/null
    or true

    # Login to get a new token
    echo "Please login to generate a new token..."
    ${pkgs.gh}/bin/gh auth login -h github.com -p https -w

    if test $status -ne 0
      echo "Error: GitHub login failed."
      return 1
    end

    # Verify token actually changed
    set -l new_token (${pkgs.gh}/bin/gh auth token 2>/dev/null)
    if test "$old_token" = "$new_token"
      echo "Warning: Token did not change. Try revoking at https://github.com/settings/connections/applications first."
    else
      echo "Token successfully regenerated."
    end

    # Save the new token into the shared secret store and export it locally.
    gh-token-save-shared
  '';

  gh-token-reset = ''
    # Unset from current session
    set -e GITHUB_TOKEN
    echo "GITHUB_TOKEN unset from current session"
  '';

  gh-token-export = ''
    set -l token (env GITHUB_TOKEN= ${pkgs.gh}/bin/gh auth token 2>/dev/null)
    if test -z "$token"
      echo "Error: Failed to get GitHub token. Please run 'gh auth login' first."
      return 1
    end

    # Export to the current session only.
    set -gx GITHUB_TOKEN $token
    echo "GITHUB_TOKEN exported to current session"
  '';

  gh-token-save-shared = ''
    set -l token (env GITHUB_TOKEN= ${pkgs.gh}/bin/gh auth token 2>/dev/null)
    if test -z "$token"
      echo "Error: Failed to get GitHub token. Please run 'gh auth login' first."
      return 1
    end

    kinko set-key GITHUB_TOKEN --shared --value "$token"
    if test $status -ne 0
      echo "Error: Failed to save GITHUB_TOKEN to kinko shared scope."
      return 1
    end

    set -gx GITHUB_TOKEN $token
    echo "Saved GITHUB_TOKEN to kinko shared scope"
    echo "GITHUB_TOKEN exported to current session"
  '';

  gh-clone = ''
    if test (count $argv) -lt 1
      echo "Usage: gh-clone <repository> [destination]" >&2
      return 1
    end

    set -l token $GITHUB_TOKEN
    if test -z "$token"
      set token (kinko get GITHUB_TOKEN --shared --reveal 2>/dev/null)
    end

    if test -z "$token"
      echo "Error: GITHUB_TOKEN is not set and could not be read from kinko. Run 'gh-token-export' or 'gh-token-save-shared', and make sure kinko is unlocked if you rely on shared secrets." >&2
      return 1
    end

    set -l repo $argv[1]
    set -e argv[1]

    switch $repo
      case 'git@github.com:*'
        set repo (string replace -r '^git@github\.com:' 'https://github.com/' -- $repo)
      case 'ssh://git@github.com/*'
        set repo (string replace -r '^ssh://git@github\.com/' 'https://github.com/' -- $repo)
    end

    env GITHUB_TOKEN="$token" git \
      -c credential.helper= \
      -c 'credential.https://github.com.helper=!f() { test "$1" = get || exit 0; test -n "$GITHUB_TOKEN" || exit 0; echo username=x-access-token; echo "password=$GITHUB_TOKEN"; }; f' \
      clone $repo $argv
  '';

}
