{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "tacogips";
        email = "me@tacogips.me";
      };
      core.editor = "${pkgs.vim}/bin/vim";
      init.defaultBranch = "main";
      pull.rebase = false;
      # Automatically convert SSH URLs to HTTPS to use gh auth credential helper
      url."https://github.com/".insteadOf = [
        "git@github.com:"
        "ssh://git@github.com/"
      ];
    };
    # Include writable config file for credential helpers
    includes = [
      { path = "~/.private/git/credential/config"; }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

}
