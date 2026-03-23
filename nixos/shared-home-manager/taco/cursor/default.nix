{ ... }:
{
  home.file.".cursor/cli-config.json".text =
    builtins.toJSON {
      version = 1;
      editor = {
        vimMode = true;
      };
      permissions = {
        allow = [ "*" ];
        deny = [ ];
      };
    }
    + "\n";
}
