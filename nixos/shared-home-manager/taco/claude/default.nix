{ ... }:
{
  # Copy handover.md to ~/.claude/commands/ for Claude slash commands
  home.file.".claude/commands/handover.md".source = ./handover.md;

  home.file.".claude/commands/cont-handover.md".source = ./cont-handover.md;
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
