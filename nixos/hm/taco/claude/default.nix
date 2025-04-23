{ ... }:
{
  home.file.".claude.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "Bash(npm run lint)"
        "Bash(npm run test:*)"
      ];
    };
  };
}
