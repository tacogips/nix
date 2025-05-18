{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # npx error?
    #nodejs_22
  ];

  ## Configure npm with defaults
  #home.file.".npmrc".text = ''
  #  prefix=${config.home.homeDirectory}/.npm-global
  #  cache=${config.home.homeDirectory}/.npm-cache
  #  init-author-name=tacogips
  #  init-license=MIT
  #'';

  ## Add npm global bin to PATH
  #home.sessionPath = [
  #  "$HOME/.npm-global/bin"
  #];

  ## Setup directory structure
  #home.activation.nodeDirectories = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #  mkdir -p $HOME/.npm-global
  #  mkdir -p $HOME/.npm-cache
  #'';
}
