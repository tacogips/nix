_:

let
  # These functions are Darwin-only additions. Shared fish functions are
  # provided by the shared module and merged by the Nix module system.
  darwinFunctions = {
    "colima-start" = {
      description = "Start Colima with default 4 CPUs and 8 GiB memory";
      body = ''
        set -l has_cpu 0
        set -l has_memory 0

        for arg in $argv
          switch $arg
            case "--cpu" "--cpu=*"
              set has_cpu 1
            case "--memory" "--memory=*"
              set has_memory 1
          end
        end

        set -l extra_args
        if test $has_cpu -eq 0
          set extra_args $extra_args --cpu 4
        end
        if test $has_memory -eq 0
          set extra_args $extra_args --memory 8
        end

        colima start $extra_args $argv
      '';
    };

    "colima-restart" = {
      description = "Restart Colima";
      body = "colima restart $argv";
    };

    "colima-stop" = {
      description = "Stop Colima";
      body = "colima stop $argv";
    };

    # Screenshot function for macOS
    screenshot = {
      description = "Take a screenshot on macOS";
      body = "screencapture -i ~/Desktop/screenshot-(date +%Y%m%d-%H%M%S).png";
    };

    # Quick Look function
    ql = {
      description = "Quick Look a file";
      body = "qlmanage -p $argv &> /dev/null";
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
darwinFunctions
