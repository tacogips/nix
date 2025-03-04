{
  config,
  pkgs,
  inputs,
  ...
}:

{

  plugins.luasnip = {
    enable = true;
  };

  plugins.cmp-path = {
    enable = true;
  };

  plugins.copilot-lua = {
    enable = true;
    settings = {
      panel = {
        enable = true;
      };

      suggestion = {

        enable = true;
      };

    };
  };

  plugins.copilot-cmp = {
    enable = true;
  };

  # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
  plugins.cmp = {
    enable = true;

    settings = {

      snippet = {
        expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };

      sources = [
        { name = "luasnip"; }
        # Adds other completion capabilites.
        #  nvim-cmp does not ship with all sources by default. They are split
        #  into multiple repos for maintenance purposes.
        { name = "nvim_lsp"; }

        { name = "crates"; }
        { name = "path"; }
        { name = "copilot"; }
        { name = "buffer"; }
      ];

    };
  };

  extraLuaPackages = ps: [
    # Required by luasnip
    ps.jsregexp
  ];

}
