{ pkgs, lib, ... }:

{
  programs.lazygit = {
    enable = true;

    #settings = {
    #  gui = {
    #    scrollHeight = 10;
    #    scrollPastBottom = true;
    #    mouseEvents = true;
    #    skipUnstageLineWarning = false;
    #    sidePanelWidth = 0.3333;
    #    expandFocusedSidePanel = false;
    #    mainPanelSplitMode = "flexible";
    #    theme = {
    #      lightTheme = false;
    #      activeBorderColor = [
    #        "green"
    #        "bold"
    #      ];
    #      inactiveBorderColor = [ "white" ];
    #      optionsTextColor = [ "blue" ];
    #    };
    #  };
    #  git = {
    #    paging = {
    #      colorArg = "always";
    #      useConfig = false;
    #    };
    #    merging = {
    #      manualCommit = false;
    #      args = "";
    #    };
    #    skipHookPrefix = "WIP";
    #    autoFetch = true;
    #    branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
    #    allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
    #  };
    #  update = {
    #    method = "never"; # コメントを外してシンプルに
    #    days = 14;
    #  };
    #  refresher = {
    #    refreshInterval = 10;
    #    fetchInterval = 60;
    #  };
    #  reporting = "off"; # コメントを外してシンプルに
    #  startupPopupVersion = 1;
    #  disableStartupPopups = true;
    #  promptToReturnFromSubprocess = false;
    #};
  };

}
