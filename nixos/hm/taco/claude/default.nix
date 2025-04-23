{ ... }:
{
  #  home.file.".claude.json".text = builtins.toJSON {
  #    permissions = {
  #      allow = [
  #        "Bash(npm run lint)"
  #        "Bash(npm run test:*)"
  #        "Bash(cargo check)"
  #        "Bash(cargo build)"
  #        "mcp__cratedocs-mcp__lookup_crate"
  #        "mcp__cratedocs-mcp__lookup_item_tool"
  #        "mcp__cratedocs-mcp__search_crates"
  #      ];
  #    };
  #    mcpServers = {
  #      cratedocs = {
  #        command = "cratedocs-mcp";
  #        args = ["stdio"];
  #        env = {};
  #      };
  #    };
  #  };
}
