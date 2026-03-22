{ mkLuaInline, ... }:
{
  settings.vim.lsp = {
    enable = true;
    formatOnSave = false;
    servers = {
      "*" = {
        root_markers = [ ".git" ];
        capabilities = mkLuaInline ''
          require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        '';
        on_attach = mkLuaInline ''
          function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        '';
      };

      ccls = { };
      gopls = { };
      julials = { };
      move_analyzer = {
        cmd = [ "move-analyzer" ];
        filetypes = [ "move" ];
        root_markers = [
          ".git"
          "Move.toml"
        ];
      };
      nil_ls = { };
      pyright = { };
      rust_analyzer = {
        settings = {
          rust-analyzer = {
            procMacro.enable = true;
            cargo.targetDir = "target/rust-analyzer";
            check = {
              command = "check";
              extraArgs = [
                "--target-dir"
                "target/ra"
              ];
            };
          };
        };
      };
      denols.root_markers = [ "deno.json" ];
      lua_ls = {
        settings = {
          Lua = {
            runtime.version = "LuaJIT";
            diagnostics.globals = [ "vim" ];
            workspace.library = mkLuaInline ''vim.api.nvim_get_runtime_file("", true)'';
            telemetry.enable = false;
          };
        };
      };
      solidity_ls = { };
      svelte = { };
      ts_ls.root_markers = [ "package.json" ];
      zls = {
        cmd = mkLuaInline ''{ "zls", "--config-path", vim.env.HOME .. "/.config/zls/zls.json" }'';
        filetypes = [
          "zig"
          "zon"
        ];
        root_markers = [
          "build.zig"
          "zls.json"
          ".git"
        ];
      };
    };
  };
}
