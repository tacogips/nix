{
  lib,
  pkgs,
  chilla-pkg ? null,
  ...
}:
let
  runtimePath = ./runtime;
  openCommand = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
  chillaCommand =
    if chilla-pkg != null then
      "${chilla-pkg}/bin/chilla"
    else if pkgs.stdenv.isDarwin then
      "chilla"
    else
      openCommand;
  mkLuaInline = lib.generators.mkLuaInline;

  mkGithubPlugin =
    {
      pname,
      owner,
      repo,
      rev,
      sha256,
    }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname;
      version = rev;
      dependencies = [ pkgs.vimPlugins.plenary-nvim ];
      src = pkgs.fetchFromGitHub {
        inherit
          owner
          repo
          rev
          sha256
          ;
      };
    };

  mermaidPlugin = mkGithubPlugin {
    pname = "mermaid-vim";
    owner = "mracos";
    repo = "mermaid.vim";
    rev = "a8470711907d47624d6860a2bcbd0498a639deb6";
    sha256 = "1ksih50xlzqrp5vgx2ix8sa1qs4h087nsrpfymkg1hm6aq4aw6rd";
  };

  commonArgs = {
    inherit
      lib
      pkgs
      runtimePath
      openCommand
      chillaCommand
      mkLuaInline
      mermaidPlugin
      ;
  };
in
{
  # Shared nvf-based Neovim configuration migrated from tacogips/dotfile_nvim.
  programs.nvf = lib.mkMerge [
    {
      enable = true;
      enableManpages = true;
    }
    (import ./base.nix commonArgs)
    (import ./autocmds.nix commonArgs)
    (import ./keymaps.nix commonArgs)
    (import ./lsp.nix commonArgs)
    (import ./ui.nix commonArgs)
    (import ./plugins/fidget.nix commonArgs)
    (import ./plugins/formatter.nix commonArgs)
    (import ./plugins/git-blame.nix commonArgs)
    (import ./plugins/hop.nix commonArgs)
    (import ./plugins/hotpot.nix commonArgs)
    (import ./plugins/lazygit.nix commonArgs)
    (import ./plugins/luasnip.nix commonArgs)
    (import ./plugins/none-ls.nix commonArgs)
    (import ./plugins/nvim-cmp.nix commonArgs)
    (import ./plugins/smart-open.nix commonArgs)
    (import ./plugins/telescope.nix commonArgs)
    (import ./plugins/toggleterm.nix commonArgs)
    (import ./plugins/mini-clue.nix commonArgs)
    (import ./plugins/yazi.nix commonArgs)
  ];
}
