{
  lib,
  pkgs,
  ...
}:
let
  runtimePath = ./runtime;
  openCommand = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
  mkLuaInline = lib.generators.mkLuaInline;

  mkExtraPlugin = package: setupPath: {
    inherit package;
    setup = builtins.readFile setupPath;
  };

  mkGithubPlugin =
    {
      pname,
      owner,
      repo,
      rev,
      sha256,
    }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname;
      version = rev;
      src = pkgs.fetchFromGitHub {
        inherit
          owner
          repo
          rev
          sha256
          ;
      };
    };

  jumpToGithubPlugin = mkGithubPlugin {
    pname = "jump-to-github-nvim";
    owner = "tacogips";
    repo = "jump_to_github.nvim";
    rev = "0e8a9ff2ba9d03d31a8e6d64bf9b84ba54b7f2c2";
    sha256 = "1k9xn54jky90gikzzr2rbfrvkih86jfns4ccxj9iwqndsayqvjl5";
  };

  zigToolsPlugin = mkGithubPlugin {
    pname = "zig-tools-nvim";
    owner = "tacogips";
    repo = "zig-tools.nvim";
    rev = "f806832f04ef58e8de4d347f7379f771cb627242";
    sha256 = "1ldqcdwix9hfnkwhahv0142cd79iv32fqa5v4k41khyc0ljzbcfm";
  };

  mermaidPlugin = mkGithubPlugin {
    pname = "mermaid-vim";
    owner = "mracos";
    repo = "mermaid.vim";
    rev = "a8470711907d47624d6860a2bcbd0498a639deb6";
    sha256 = "1ksih50xlzqrp5vgx2ix8sa1qs4h087nsrpfymkg1hm6aq4aw6rd";
  };
in
{
  # Shared nvf-based Neovim configuration migrated from tacogips/dotfile_nvim.
  programs.nvf = {
    enable = true;
    enableManpages = true;

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

      augroups = [
        {
          name = "TrimWhitespace";
          clear = true;
        }
      ];

      autocmds = [
        {
          event = [ "BufWritePre" ];
          pattern = [ "*" ];
          group = "TrimWhitespace";
          command = "%s/\\s\\+$//ge";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "*.{md,mdwn,mkd,mkdn,mark*}" ];
          command = "set filetype=markdown";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "*.dig" ];
          command = "set filetype=yaml";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "*.vtl" ];
          command = "set ft=velocity";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "nginx.conf" ];
          command = "set ft=nginx";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "Dockerfile*" ];
          command = "set filetype=dockerfile";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "*.png" ];
          command = "setlocal filetype=png";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [
            "*.jpg"
            "*.jpeg"
          ];
          command = "setlocal filetype=jpeg";
        }
        {
          event = [
            "BufNewFile"
            "BufRead"
          ];
          pattern = [ "*.zon" ];
          command = "set filetype=zig";
        }
        {
          event = [ "Syntax" ];
          pattern = [ "yaml" ];
          command = "setlocal indentkeys-=<:> indentkeys-=0#";
        }
        {
          event = [ "FileType" ];
          pattern = [ "go" ];
          command = "nmap <buffer> .r <ESC>:GoRun<CR> | nmap <buffer> .b <ESC>:GoBuild<CR> | nmap <buffer> .t <ESC>:GoTest<CR> | nmap <buffer> .l <ESC>:GoLint<CR> | nmap <buffer> .v <ESC>:GoVet<CR>";
        }
        {
          event = [ "FileType" ];
          pattern = [ "go" ];
          command = "match goErr /\\<err\\>/ | highlight goErr cterm=bold ctermfg=214";
        }
        {
          event = [ "FileType" ];
          pattern = [ "plantuml" ];
          command = "nmap <buffer> .r <ESC>:make<CR>";
        }
        {
          event = [ "FileType" ];
          pattern = [ "python" ];
          command = "noremap <buffer> .t <ESC>:TestFile<CR>";
        }
        {
          event = [ "FileType" ];
          pattern = [ "rust" ];
          command = "nmap <buffer> .f <ESC>:Cargo fix<CR> | nmap <buffer> .r <ESC>:Cargo run<CR> | nmap <buffer> .b <ESC>:Cargo check<CR> | nmap <buffer> .l <ESC>:Cargo clippy<CR> | nmap <buffer> .t <ESC>:Cargo nextest run<CR>";
        }
        {
          event = [ "FileType" ];
          pattern = [ "typescript" ];
          command = "inoremap <buffer> <C-Space> <C-x><C-o>";
        }
        {
          event = [ "FileType" ];
          pattern = [ "zig" ];
          command = "nmap <buffer> .b <ESC>:Zig build<CR> | nmap <buffer> .t <ESC>:Zig task test<CR> | nmap <buffer> .r <ESC>:Zig run<CR>";
        }
      ];

      keymaps = [
        {
          mode = "c";
          key = "<C-g>";
          action = "<C-c>";
        }
        {
          mode = "c";
          key = "<C-a>";
          action = "<C-b>";
        }
        {
          mode = "i";
          key = "<C-d>";
          action = "<Delete>";
        }
        {
          mode = "i";
          key = "<C-h>";
          action = "<Bs>";
        }
        {
          mode = "i";
          key = "<C-f>";
          action = "<Right>";
        }
        {
          mode = "i";
          key = "<C-b>";
          action = "<Left>";
        }
        {
          mode = "i";
          key = "kj";
          action = "<ESC><ESC>";
        }
        {
          mode = "i";
          key = "<C-v>";
          action = "<C-R>+";
        }
        {
          mode = "i";
          key = "<ESC>";
          action = "<ESC>:set iminsert=0<CR>";
        }
        {
          mode = "i";
          key = "<C-j>";
          action = "<nop>";
        }
        {
          mode = "i";
          key = "<C-a>";
          action = "<Cmd>lua vimrc.cmp.lsp()<CR>";
        }
        {
          mode = "n";
          key = "Q";
          action = "<Nop>";
        }
        {
          mode = "n";
          key = "gQ";
          action = "<Nop>";
        }
        {
          mode = "n";
          key = "<Esc><Esc>";
          action = ":set nohlsearch<CR>";
        }
        {
          mode = "n";
          key = "j";
          action = "gj";
        }
        {
          mode = "n";
          key = "k";
          action = "gk";
        }
        {
          mode = "n";
          key = "+";
          action = "g;";
        }
        {
          mode = "n";
          key = "J";
          action = "gJ";
        }
        {
          mode = "n";
          key = "bp";
          action = ":bprevious<CR>";
        }
        {
          mode = "n";
          key = "bn";
          action = ":bnext<CR>";
        }
        {
          mode = "n";
          key = "<Space>.";
          action = ":<C-u>so $MYVIMRC<CR>";
        }
        {
          mode = "n";
          key = ".vr";
          action = ":%y\\|@\"<CR>";
        }
        {
          mode = "n";
          key = ",w";
          action = ":write<CR>";
        }
        {
          mode = "n";
          key = "<Space>w";
          action = ":write<CR>";
        }
        {
          mode = "n";
          key = ".y";
          action = ":let @+=getcwd()<CR>";
        }
        {
          mode = "n";
          key = "<Space><Space>";
          action = "i <Esc><Right>";
        }
        {
          mode = "n";
          key = "<Space>j";
          action = "i<CR><ESC>";
        }
        {
          mode = "n";
          key = "<Space>x";
          action = "xi<Space><ESC>";
        }
        {
          mode = "n";
          key = "<Space>n";
          action = ":bn!<CR>";
        }
        {
          mode = "n";
          key = "<Space>b";
          action = ":bp!<CR>";
        }
        {
          mode = "n";
          key = "<Space>o";
          action = ":on!<CR>";
        }
        {
          mode = "n";
          key = "<Space>q";
          action = ":q!<CR>";
        }
        {
          mode = "n";
          key = "<Space>1";
          action = ":qa!<CR>";
        }
        {
          mode = "n";
          key = "<Space>r";
          action = ":QuickRun<CR>";
        }
        {
          mode = "n";
          key = "<Space>t";
          action = "<cmd>AerialToggle!<CR>";
        }
        {
          mode = "n";
          key = ",e";
          action = ":e! %<CR>";
        }
        {
          mode = "n";
          key = ",y";
          action = ":tabo<CR>";
        }
        {
          mode = "n";
          key = ",.";
          action = "<CMD>lua require'telescope.builtin'.git_status{}<Cr>";
        }
        {
          mode = "n";
          key = ",c";
          action = "<CMD>lua require'telescope.builtin'.git_commits{}<Cr>";
        }
        {
          mode = "n";
          key = ",,";
          action = "<CMD>:Telescope oldfiles<Cr>";
        }
        {
          mode = "n";
          key = ",b";
          action = "<CMD>lua require'telescope.builtin'.buffers{}<CR>";
        }
        {
          mode = "n";
          key = ",f";
          action = "<CMD>lua require'telescope.builtin'.git_files{}<Cr>";
        }
        {
          mode = "n";
          key = ",g";
          action = "<CMD>lua require'telescope.builtin'.live_grep{}<Cr>";
        }
        {
          mode = "n";
          key = ",l";
          action = "<CMD>lua require'telescope.builtin'.git_branches{}<Cr>";
        }
        {
          mode = "n";
          key = ",m";
          action = "<CMD>lua require'telescope.builtin'.marks{}<Cr>";
        }
        {
          mode = "n";
          key = ",h";
          action = "<CMD>lua require'telescope.builtin'.command_history{}<Cr>";
        }
        {
          mode = "n";
          key = ",k";
          action = "<CMD>lua require'telescope.builtin'.keymaps{}<Cr>";
        }
        {
          mode = "n";
          key = ",z";
          action = "<CMD>lua require'telescope.builtin'.lsp_references{}<Cr>";
        }
        {
          mode = "n";
          key = ",x";
          action = "<CMD>lua require'telescope.builtin'.lsp_implementations{}<Cr>";
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
        }
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
        }
        {
          mode = "n";
          key = "<C-e>";
          action = ":vsplit<CR>";
        }
        {
          mode = "n";
          key = "cl";
          action = ":%s/.//gn<CR>";
        }
        {
          mode = "n";
          key = "<C-]>";
          action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
        }
        {
          mode = "n";
          key = "<C-\\>";
          action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
        }
        {
          mode = "n";
          key = "<C-n>";
          action = "<Cmd>lua vim.lsp.buf.hover()<CR>";
        }
        {
          mode = "n";
          key = ".j";
          action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
        }
        {
          mode = "n";
          key = ".e";
          action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        }
        {
          mode = "n";
          key = "<space>ca";
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        }
        {
          mode = "n";
          key = "<C-s>";
          action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        }
        {
          mode = "n";
          key = "<C-g>";
          action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        }
        {
          mode = "n";
          key = ".w";
          action = "<cmd>lua vim.diagnostic.set_loclist()<CR>";
        }
        {
          mode = "n";
          key = ".\\";
          action = ":LspRestart<CR>";
        }
        {
          mode = "v";
          key = "kj";
          action = "<ESC><ESC>";
        }
        {
          mode = "n";
          key = "r";
          action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
        }
        {
          mode = "v";
          key = "r";
          action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
        }
        {
          mode = "n";
          key = "f";
          action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
        }
        {
          mode = "v";
          key = "f";
          action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
        }
      ];

      luaConfigRC = ''
        vim.cmd.colorscheme("iceberg")
        vim.cmd.iabbrev("todo TODO")
        vim.cmd([[
        let g:quickrun_config = {
              \  'julia' : {
              \    'command': 'julia',
              \    'exec':'%c --project %s'
              \  },
              \  'typescript' : {
              \    'command': 'bun',
              \    'exec':'%s',
              \    'hook/cd/directory': '%S:p:h'
              \  }
              \}
        ]])

        require("vim.treesitter.query").set(
          "markdown",
          "highlights",
          [[
        ;From MDeiml/tree-sitter-markdown
        [
          (fenced_code_block_delimiter)
        ] @punctuation.delimiter
        ]]
        )

        for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
          vim.api.nvim_set_hl(0, group, {})
        end
      '';

      lsp = {
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
                require("aerial").on_attach(client, bufnr)
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
                cargo = { };
                checkOnSave = { };
              };
            };
          };
          denols = {
            root_markers = [ "deno.json" ];
          };
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
          ts_ls = {
            root_markers = [ "package.json" ];
          };
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

      statusline.lualine = {
        enable = true;
        theme = "iceberg";
        componentSeparator = {
          left = "";
          right = "|";
        };
        sectionSeparator = {
          left = "";
          right = "";
        };
        alwaysDivideMiddle = true;
        activeSection = {
          a = [ "mode" ];
          b = [ ];
          c = [ "filename" ];
          x = [
            "encoding"
            "fileformat"
          ];
          y = [ "location" ];
          z = [
            "filetype"
            "branch"
            "diff"
            "diagnostics"
          ];
        };
        extraActiveSection.c = [
          {
            __unkeyed-1 = "filename";
            path = 2;
          }
        ];
        inactiveSection = {
          a = [ ];
          b = [ ];
          c = [ "filename" ];
          x = [ "location" ];
          y = [ ];
          z = [ ];
        };
      };

      treesitter = {
        highlight = {
          enable = true;
          additionalVimRegexHighlighting = false;
          disable = [
            "c"
            "rust"
            "python"
            "javascript"
            "typescript"
            "json"
            "toml"
            "typescriptreact"
          ];
        };
      };

      lazy.plugins = {
        fidget-nvim = {
          package = pkgs.vimPlugins.fidget-nvim;
          setupModule = "fidget";
          setupOpts = { };
        };
        crates-nvim = {
          package = pkgs.vimPlugins.crates-nvim;
          setupModule = "crates";
          setupOpts.null_ls = {
            enabled = true;
            name = "crates.nvim";
          };
        };
        git-blame-nvim = {
          package = pkgs.vimPlugins.git-blame-nvim;
          setupModule = "gitblame";
          setupOpts.enabled = false;
        };
        hotpot-nvim = {
          package = pkgs.vimPlugins.hotpot-nvim;
          setupModule = "hotpot";
          setupOpts = {
            provide_require_fennel = false;
            enable_hotpot_diagnostics = true;
            compiler.macros.env = "_COMPILER";
          };
        };
        hop-nvim = {
          package = pkgs.vimPlugins.hop-nvim;
          setupModule = "hop";
          setupOpts.keys = "fdjhklsagqwertyuiopzxcvbnm";
        };
        luasnip = {
          package = pkgs.vimPlugins.luasnip;
          after = ''
            require("luasnip.loaders.from_snipmate").load()
          '';
        };
        nvim-cmp = {
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
        null-ls-nvim = {
          package = pkgs.vimPlugins.null-ls-nvim;
          setupModule = "null-ls";
          setupOpts.sources = mkLuaInline ''
            {
              require("null-ls").builtins.formatting.stylua,
              require("null-ls").builtins.diagnostics.eslint,
              require("null-ls").builtins.completion.spell,
            }
          '';
        };
        telescope-nvim = {
          package = pkgs.vimPlugins.telescope-nvim;
          setupModule = "telescope";
          after = ''
            require("telescope").load_extension("aerial")
          '';
          setupOpts = {
            defaults = {
              prompt_prefix = " ❯ ";
              sorting_strategy = "descending";
              layout_config.prompt_position = "bottom";
              mappings.i = {
                "<ESC>" = mkLuaInline ''require("telescope.actions").close'';
                "<C-j>" = mkLuaInline ''require("telescope.actions").move_selection_next'';
                "<C-k>" = mkLuaInline ''require("telescope.actions").move_selection_previous'';
                "<TAB>" =
                  mkLuaInline ''require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_next'';
                "<C-s>" = mkLuaInline ''require("telescope.actions").send_selected_to_qflist'';
                "<C-q>" = mkLuaInline ''require("telescope.actions").send_to_qflist'';
              };
            };
            extensions = {
              aerial.show_nesting = true;
              fzf = {
                fuzzy = true;
                override_generic_sorter = true;
                override_file_sorter = true;
                case_mode = "smart_case";
              };
            };
          };
        };
        toggleterm-nvim = {
          package = pkgs.vimPlugins.toggleterm-nvim;
          setupModule = "toggleterm";
          setupOpts = { };
        };
        zig-tools.nvim = {
          package = zigToolsPlugin;
          setupModule = "zig-tools";
          setupOpts = {
            expose_commands = true;
            formatter = {
              enable = false;
              events = [ ];
            };
            checker = {
              enable = false;
              before_compilation = false;
              events = [ ];
            };
            project = {
              build_tasks = true;
              live_reload = true;
              flags = {
                build = [ "-freference-trace" ];
                run = [ "-freference-trace" ];
              };
              auto_compile = {
                enable = false;
                run = true;
              };
            };
            integrations = {
              package_managers = [
                "zigmod"
                "gyro"
              ];
              zls = {
                hints = false;
                management = {
                  enable = false;
                  install_path = mkLuaInline ''os.getenv("HOME") .. "/.nix-profile/bin"'';
                  source_path = mkLuaInline ''os.getenv("HOME") .. "/.local/zig/zls"'';
                };
              };
            };
            terminal = {
              insert_mappings = false;
              terminal_mappings = false;
              direction = "horizontal";
              auto_scroll = true;
              close_on_exit = false;
            };
          };
        };
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
        aerial = mkExtraPlugin aerial-nvim ./runtime/lua/plugins/aerial.lua;
        cmp-buffer.package = cmp-buffer;
        cmp-cmdline.package = cmp-cmdline;
        cmp-nvim-lsp.package = cmp-nvim-lsp;
        cmp-path.package = cmp-path;
        cmp_luasnip.package = cmp_luasnip;
        copilot.package = copilot-vim;
        dart.package = dart-vim-plugin;
        editorconfig.package = editorconfig-vim;
        formatter = mkExtraPlugin formatter-nvim ./runtime/lua/plugins/formatter.lua;
        iceberg.package = iceberg-vim;
        jinja.package = jinja-vim;
        jump-to-github = {
          package = jumpToGithubPlugin;
          setup = ''
            require("jump_to_github").setup({
              open_browser = vim.g.taco_browser_open_cmd or "xdg-open",
            })
          '';
        };
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
  };
}
