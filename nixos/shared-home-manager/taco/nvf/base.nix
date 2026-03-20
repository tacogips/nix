{
  lib,
  pkgs,
  runtimePath,
  openCommand,
  mermaidPlugin,
  ...
}:
{
  settings.vim = {
    additionalRuntimePaths = [ runtimePath ];
    enableLuaLoader = true;
    syntaxHighlighting = true;
    searchCase = "smart";

    globals = {
      hybrid_custom_term_colors = 1;
      hybrid_reduced_contrast = 1;
      go_fmt_autosave = 0;
      go_fmt_command = "goimports";
      go_fmt_fail_silently = 1;
      go_list_type = "quickfix";
      go_gocode_propose_builtins = 1;
      go_gocode_propose_source = 0;
      go_gocode_socket_type = "unix";
      go_gocode_unimported_packages = 1;
      go_highlight_build_constraints = 1;
      go_highlight_functions = 1;
      go_highlight_interfaces = 1;
      go_highlight_methods = 1;
      go_highlight_operators = 1;
      go_highlight_structs = 1;
      go_jump_to_error = 1;
      python3_host_prog = lib.getExe pkgs.python3;
      rustfmt_autosave = 0;
      taco_open_cmd = openCommand;
      taco_browser_open_cmd = openCommand;
    };

    options = {
      autochdir = true;
      autoread = true;
      clipboard = "unnamedplus";
      cursorline = true;
      expandtab = false;
      history = 2000;
      magic = true;
      number = true;
      shada = "'2000,f1,<50";
      shortmess = "atI";
      shiftwidth = 2;
      showmatch = true;
      softtabstop = 0;
      tabstop = 2;
      title = true;
      visualbell = true;
      wildmenu = true;
      wildmode = "list:full";
      wrapscan = true;
    };

    extraPackages =
      with pkgs;
      [
        basedpyright
        black
        fd
        git
        gopls
        lua-language-server
        nil
        nodePackages.prettier
        nodePackages.typescript
        nodePackages.typescript-language-server
        python3
        ripgrep
        rust-analyzer
        rustfmt
        shfmt
        stylua
        taplo
        zls
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        xdg-utils
      ];

    extraPlugins = with pkgs.vimPlugins; {
      cmp-buffer.package = cmp-buffer;
      cmp-cmdline.package = cmp-cmdline;
      cmp-nvim-lsp.package = cmp-nvim-lsp;
      cmp-path.package = cmp-path;
      cmp_luasnip.package = cmp_luasnip;
      copilot.package = copilot-vim;
      dart.package = dart-vim-plugin;
      editorconfig.package = editorconfig-vim;
      iceberg.package = iceberg-vim;
      jinja.package = jinja-vim;
      kdl.package = kdl-vim;
      lsp_extensions.package = lsp_extensions-nvim;
      mermaid.package = mermaidPlugin;
      nginx.package = nginx-vim;
      nim.package = nim-vim;
      nvim-lspconfig.package = nvim-lspconfig;
      pest.package = pest-vim;
      plenary.package = plenary-nvim;
      rust.package = rust-vim;
      telescope-fzf.package = telescope-fzf-native-nvim;
      telescope-symbols.package = telescope-symbols-nvim;
      tokyonight.package = tokyonight-nvim;
      venn.package = venn-nvim;
      vim-cpp.package = vim-cpp-enhanced-highlight;
      vim-dispatch.package = vim-dispatch;
      vim-endwise.package = vim-endwise;
      vim-flutter.package = vim-flutter;
      vim-go.package = vim-go;
      vim-graphql.package = vim-graphql;
      vim-hybrid.package = vim-hybrid;
      vim-just.package = vim-just;
      vim-markdown.package = vim-markdown;
      vim-quickrun.package = vim-quickrun;
      vim-ruby.package = vim-ruby;
      vim-solidity.package = vim-solidity;
      vim-svelte.package = vim-svelte;
      vim-surround.package = vim-surround;
      vim-terraform.package = vim-terraform;
      vim-test.package = vim-test;
      vim-toml.package = vim-toml;
    };
  };
}
