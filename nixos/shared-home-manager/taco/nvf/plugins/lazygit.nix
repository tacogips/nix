{ pkgs, ... }:
{
  settings.vim.lazy.plugins."lazygit.nvim" = {
    package = pkgs.vimPlugins.lazygit-nvim;
    cmd = [
      "LazyGit"
      "LazyGitConfig"
      "LazyGitCurrentFile"
      "LazyGitFilter"
      "LazyGitFilterCurrentFile"
    ];
  };
}
