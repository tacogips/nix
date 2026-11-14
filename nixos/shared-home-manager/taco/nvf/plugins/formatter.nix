{ pkgs, mkLuaInline, ... }:
{
  settings.vim.lazy.plugins."formatter.nvim" = {
    package = pkgs.vimPlugins.formatter-nvim;
    setupModule = "formatter";
    setupOpts = {
      logging = false;
      log_level = mkLuaInline "vim.log.levels.WARN";
      filetype = {
        typescript = [ (mkLuaInline ''require("formatter.filetypes.typescript").prettier'') ];
        javascript = [ (mkLuaInline ''require("formatter.filetypes.javascript").prettier'') ];
        typescriptreact = [ (mkLuaInline ''require("formatter.filetypes.typescriptreact").prettier'') ];
        vue = [ (mkLuaInline ''require("formatter.util").copyf(require("formatter.defaults").prettier)'') ];
        svelte = [
          (mkLuaInline ''require("formatter.util").copyf(require("formatter.defaults").prettier)'')
        ];
        proto = [
          (mkLuaInline ''
            function()
              return {
                exe = "buf",
                args = { "format" },
                stdin = true,
              }
            end
          '')
        ];
        graphql = [ (mkLuaInline ''require("formatter.filetypes.graphql").prettier'') ];
        html = [ (mkLuaInline ''require("formatter.filetypes.html").prettier'') ];
        c = [ (mkLuaInline ''require("formatter.filetypes.c").clangformat'') ];
        solidity = [
          (mkLuaInline ''
            function()
              return {
                exe = "forge",
                args = { "fmt", "--raw", "-" },
                stdin = true,
              }
            end
          '')
        ];
        css = [ (mkLuaInline ''require("formatter.filetypes.css").prettier'') ];
        yaml = [ (mkLuaInline ''require("formatter.filetypes.yaml").prettier'') ];
        sql = [
          (mkLuaInline ''
            function()
              return {
                exe = "sqlfmt",
                args = { "-" },
                stdin = true,
              }
            end
          '')
        ];
        terraform = [
          (mkLuaInline ''
            function()
              return {
                exe = "terraform",
                args = { "fmt", "-" },
                stdin = true,
              }
            end
          '')
        ];
        python = [
          (mkLuaInline ''
            function()
              return {
                exe = "black",
                args = { "-q", "-" },
                stdin = true,
              }
            end
          '')
        ];
        rust = [
          (mkLuaInline ''
            function()
              return {
                exe = "rustfmt",
                args = { "--edition", "2021" },
                stdin = true,
              }
            end
          '')
        ];
        go = [ (mkLuaInline ''require("formatter.filetypes.go").goimports'') ];
        json = mkLuaInline ''require("formatter.filetypes.json").prettier'';
        zig = [
          (mkLuaInline ''
            function()
              return {
                exe = "zig",
                args = { "fmt", "--stdin" },
                stdin = true,
              }
            end
          '')
        ];
        toml = [
          (mkLuaInline ''
            function()
              if require("formatter.util").get_current_buffer_file_name() == "Cargo.lock" then
                return nil
              end
              return {
                exe = "taplo",
                args = { "fmt", "-" },
                stdin = true,
                try_node_modules = true,
              }
            end
          '')
        ];
        lua = [ (mkLuaInline ''require("formatter.filetypes.lua").stylua'') ];
        fennel = [
          (mkLuaInline ''
            function()
              return {
                exe = "fnlfmt",
                args = { "-" },
                stdin = true,
              }
            end
          '')
        ];
        nix = [
          (mkLuaInline ''
            function()
              return {
                exe = "nixfmt",
                args = {},
                stdin = true,
              }
            end
          '')
        ];
        "*" = [ (mkLuaInline ''require("formatter.filetypes.any").remove_trailing_whitespace'') ];
      };
    };
  };
}
