{ pkgs, mkLuaInline, ... }:
{
  settings.vim.lazy.plugins.nvim-cmp = {
    package = pkgs.vimPlugins.nvim-cmp;
    setupModule = "cmp";
    setupOpts = {
      snippet.expand = mkLuaInline ''
        function(args)
          require("luasnip").lsp_expand(args.body)
        end
      '';
      mapping = mkLuaInline ''
        require("cmp").mapping.preset.insert({
          ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
        })
      '';
      sources = mkLuaInline ''
        require("cmp").config.sources({
          { name = "luasnip" },
          { name = "crates" },
          { name = "path" },
        }, {
          { name = "buffer" },
        })
      '';
    };
    after = ''
      local cmp = require("cmp")

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }, {
          { name = "buffer" },
        }),
      })

      _G.vimrc = _G.vimrc or {}
      _G.vimrc.cmp = _G.vimrc.cmp or {}
      _G.vimrc.cmp.lsp = function()
        cmp.complete({
          config = {
            sources = {
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            },
          },
        })
      end
    '';
  };
}
