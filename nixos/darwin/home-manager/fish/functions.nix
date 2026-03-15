{ pkgs }:

let
  # Import shared functions
  sharedFunctions = import ../../../shared-home-manager/taco/fish/functions.nix { inherit pkgs; };
  
  # Darwin-specific functions
  darwinFunctions = {
    # Screenshot function for macOS
    screenshot = {
      description = "Take a screenshot on macOS";
      body = ''screencapture -i ~/Desktop/screenshot-(date +%Y%m%d-%H%M%S).png'';
    };
    
    # Quick Look function
    ql = {
      description = "Quick Look a file";
      body = ''qlmanage -p $argv &> /dev/null'';
    };
    
    # Show/hide hidden files in Finder
    toggle_hidden = {
      description = "Toggle hidden files in Finder";
      body = ''
        set -l current (defaults read com.apple.finder AppleShowAllFiles)
        if test $current = "YES"
          defaults write com.apple.finder AppleShowAllFiles NO
          echo "Hidden files will be hidden"
        else
          defaults write com.apple.finder AppleShowAllFiles YES
          echo "Hidden files will be shown"
        end
        killall Finder
      '';
    };
  };

in
  # Merge shared functions with Darwin-specific ones
  sharedFunctions // darwinFunctions