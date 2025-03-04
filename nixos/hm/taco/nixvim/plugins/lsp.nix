{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
  plugins.cmp-nvim-lsp = {
    enable = true;
  };

  # https://nix-community.github.io/nixvim/plugins/fidget/index.html
  plugins.fidget = {
    enable = true;
  };

  # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
  autoGroups = {
    "kickstart-lsp-attach" = {
      clear = true;
    };
  };

  plugins.lsp = {
    enable = true;

    servers = {
      # clangd = {
      #  enable = true;
      #}
      bashls = {
        enable = true;
      };
      cssls = {
        enable = true;
      };
      html = {
        enable = true;
        filetypes = [
          "html"
          "templ"
        ];
      };
      htmx = {
        enable = true;
        filetypes = [
          "html"
          "templ"
        ];
      };
      tailwindcss = {
        enable = true;
        filetypes = [
          "html"
          "css"
          "scss"
          "sass"
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "vue"
          "rust"
          "rs"
          "templ"
          "svelte"
        ];
        rootDir = ''
          require 'lspconfig'.util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts', 'package.json')
        '';
        extraOptions = {
          init_options = {
            userLanguages = {
              rust = "html";
              templ = "html";
            };
          };
        };
      };
      dockerls = {
        enable = true;
      };
      jsonls = {
        enable = true;
      };
      svelte = {
        enable = true;
      };
      gopls = {
        enable = true;
      };
      pyright = {
        enable = true;
      };
      rust-analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
      tsserver = {
        enable = true;
      };
      templ = {
        enable = true;
      };
      nil-ls = {
        enable = true;
      };
      terraformls = {
        enable = true;
      };

      yamlls = {
        enable = true;
      };

      zls = {
        enable = true;
      };

      lua-ls = {
        enable = true;

        settings = {
          completion = {
            callSnippet = "Replace";
          };
        };
      };
    };

    keymaps = {
      # Diagnostic keymaps
      diagnostic = {
        "<C-s>" = {
          action = "goto_prev";
          desc = "Go to previous [D]iagnostic message";
        };
        "<C-g>" = {
          action = "goto_next";
          desc = "Go to next [D]iagnostic message";
        };
        ".w" = {
          #mode = "n";
          action = "setloclist";
          desc = "Open diagnostic [Q]uickfix list";
        };
      };

      extra = [
        # Jump to the definition of the word under your cusor.
        #  This is where a variable was first declared, or where a function is defined, etc.
        #  To jump back, press <C-t>.
        {
          mode = "n";
          key = "<C-]>";
          action.__raw = "require('telescope.builtin').lsp_definitions";
        }
        # Find references for the word under your cursor.
        {
          mode = "n";
          key = ".z";
          action.__raw = "require('telescope.builtin').lsp_references";
        }
        {
          mode = "n";
          key = ".x";
          action.__raw = "require('telescope.builtin').lsp_implementations";
        }
        {
          mode = "n";
          key = "<C-\\>";
          action.__raw = "require('telescope.builtin').lsp_type_definitions";
        }
        {
          mode = "n";
          key = "<leader>ds";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
          options = {
            desc = "LSP: [D]ocument [S]ymbols";
          };
        }
      ];

      lspBuf = {
        ".e" = {
          #mode = "n"; TODO: FIGURE OUT HOW TO SET THIS
          action = "rename";
        };
        "<space>ca" = {
          action = "code_action";
          desc = "LSP: [C]ode [A]ction";
        };
        # Opens a popup that displays documentation about the word under your cursor
        #  See `:help K` for why this keymap.
        "K" = {
          action = "hover";
          desc = "LSP: Hover Documentation";
        };
        # WARN: This is not Goto Definition, this is Goto Declaration.
        #  For example, in C this would take you to the header.
        "gD" = {
          action = "declaration";
          desc = "LSP: [G]oto [D]eclaration";
        };
      };
    };

    onAttach = ''

    '';
  };
}
