{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      # Claude MCP management aliases

      # Add all MCP servers to current project's local scope
      claude-mcp-add-all = ''
        claude mcp add --scope local --transport stdio github-insight-mcp github-insight-mcp stdio && \
        claude mcp add --scope local --transport stdio github-edit-mcp github-edit-mcp stdio && \
        claude mcp add --scope local --transport stdio cratedocs-mcp cratedocs-mcp stdio && \
        echo "✅ All MCP servers added to local scope"
      '';

      # Individual MCP server addition aliases
      claude-mcp-add-github-insight = "claude mcp add --scope local --transport stdio github-insight-mcp github-insight-mcp stdio";
      claude-mcp-add-github-edit = "claude mcp add --scope local --transport stdio github-edit-mcp github-edit-mcp stdio";
      claude-mcp-add-cratedocs = "claude mcp add --scope local --transport stdio cratedocs-mcp cratedocs-mcp stdio";
    };

    initExtra = ''
      # Claude MCP helper function
      claude-mcp-add-custom() {
        if [ -z "$1" ] || [ -z "$2" ]; then
          echo "Usage: claude-mcp-add-custom <name> <command> [args...]"
          echo "Example: claude-mcp-add-custom my-server my-server-command stdio"
          return 1
        fi

        local name="$1"
        local command="$2"
        shift 2

        claude mcp add --scope local --transport stdio "$name" "$command" "$@"
      }
    '';
  };
}
