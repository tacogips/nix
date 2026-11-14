{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user = {
        name = "tacogips";
        email = "me@tacogips.me";
      };
      core.editor = "${pkgs.vim}/bin/vim";
      init.defaultBranch = "main";
      pull.rebase = false;
      # Automatically convert SSH URLs to HTTPS so Git can use the HTTPS credential helper.
      url."https://github.com/".insteadOf = [
        "git@github.com:"
        "ssh://git@github.com/"
      ];
      credential = {
        "https://github.com" = {
          helper = [
            ""
            "!f() { test \"$1\" = get || exit 0; test -n \"$GITHUB_TOKEN\" || exit 0; echo username=x-access-token; echo \"password=$GITHUB_TOKEN\"; }; f"
          ];
        };
        "https://gist.github.com" = {
          helper = [
            ""
            "!f() { test \"$1\" = get || exit 0; test -n \"$GITHUB_TOKEN\" || exit 0; echo username=x-access-token; echo \"password=$GITHUB_TOKEN\"; }; f"
          ];
        };
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

}
