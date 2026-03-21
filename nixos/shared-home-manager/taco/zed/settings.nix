{ ... }:

{
  collaboration_panel = {
    dock = "right";
  };

  theme = {
    mode = "system";
    light = "Catppuccin Latte";
    dark = "Catppuccin Mocha";
  };
  icon_theme = "Catppuccin Icons";
  base_keymap = "VSCode";
  features = {
    edit_prediction_provider = "zed";
  };
  buffer_font_family = "Iosevka";
  buffer_font_size = 12;
  ui_font_size = 12;
  cursor_blink = true;
  vim_mode = true;
  format_on_save = "on";
  confirm_quit = false;
  telemetry = {
    diagnostics = false;
    metrics = true;
  };

  active_pane_modifiers = {
    magnification = 1.5;
    border_size = 2.0;
    inactive_opacity = 0.3;
  };

  terminal = {
    font_family = "Iosevka";
    font_size = 12;
    dock = "bottom";
  };

  agent = {
    enabled = true;
    button = true;
    dock = "right";
    default_width = 640;
    default_height = 320;
    default_model = {
      provider = "anthropic";
      model = "claude-sonnet-4-latest";
    };
    editor_model = {
      provider = "anthropic";
      model = "claude-sonnet-4-latest";
    };
    always_allow_tool_actions = true;
    single_file_review = true;
    default_profile = "write";
    profiles = {
      write = {
        name = "Write";
        enable_all_context_servers = true;
        tools = {
          copy_path = true;
          create_directory = true;
          create_file = true;
          delete_path = false;
          diagnostics = true;
          edit_file = true;
          fetch = true;
          list_directory = true;
          move_path = false;
          now = true;
          find_path = true;
          read_file = true;
          grep = true;
          terminal = true;
          thinking = true;
          web_search = true;
        };
      };
      ask = {
        name = "Ask";
        tools = {
          contents = true;
          diagnostics = true;
          fetch = true;
          list_directory = true;
          now = true;
          find_path = true;
          read_file = true;
          open = true;
          grep = true;
          thinking = true;
          web_search = true;
        };
      };
      minimal = {
        name = "Minimal";
        enable_all_context_servers = false;
        tools = { };
      };
    };
    notify_when_agent_waiting = "primary_screen";
  };

  context_servers = {
    "cratedocs-mcp" = {
      "source" = "custom";
      "command" = "cratedocs-mcp";
      "args" = [ "stdio" ];
      "env" = { };
    };

    "gitcodes-mcp" = {
      "source" = "custom";
      "command" = "gitcodes-mcp";
      "args" = [ "stdio" ];
      "env" = { };
    };

    "bravesearch-mcp" = {
      "source" = "custom";
      "command" = "bravesearch-mcp";
      "args" = [ "stdio" ];
      "env" = { };
    };
  };

  edit_predictions = {
    disabled_globs = [
      "**/.env*"
      "**/*.pem"
      "**/*.key"
      "**/*.cert"
      "**/*.crt"
      "**/.dev.vars"
      "**/secrets.yml"
      "**/secrets*"
      "**/*.private*"
    ];
    mode = "eager";
    enabled_in_text_threads = true;
  };

  languages = {
    "C" = {
      format_on_save = "off";
      use_on_type_format = false;
      prettier = {
        allowed = false;
      };
    };
    "C++" = {
      format_on_save = "off";
      use_on_type_format = false;
      prettier = {
        allowed = false;
      };
    };
    "Toml" = {
      format_on_save = "off";
    };
    "Nix" = {
      language_servers = [
        "nil"
        "..."
      ];
      formatter = {
        external = {
          command = "nixfmt";
        };
      };
    };
    "YAML" = {
      format_on_save = "off";
    };
    "Python" = {
      language_servers = [
        "pyright"
      ];
      format_on_save = "on";
      formatter = [
        {
          external = {
            command = "ruff";
            arguments = [
              "format"
              "--stdin-filename"
              "{buffer_path}"
              "-"
            ];
          };
        }
      ];
    };
    "Go" = {
      language_servers = [
        "gopls"
      ];
      format_on_save = "on";
      formatter = {
        external = {
          command = "goimports";
        };
      };
      code_actions_on_format = {
        "source.organizeImports" = true;
      };
    };
    "Svelte" = {
      language_servers = [
        "svelte-language-server"
        "..."
      ];
      format_on_save = "on";
      formatter = {
        language_server = {
          name = "svelte-language-server";
        };
      };
    };
  };

  lsp = {
    rust-analyzer = {
      check = {
        extraArgs = [
          "--target-dir"
          "target/ra"
        ];
      };
      initialization_options = {
        rust = {
          analyzerTargetDir = "target/rust-analyzer";
        };
        check = {
          command = "check";
        };
      };
    };
    gopls = {
      initialization_options = {
        usePlaceholders = true;
        completeUnimported = true;
        staticcheck = true;
        gofumpt = true;
        analyses = {
          unusedparams = true;
          shadow = true;
        };
        codelenses = {
          generate = true;
          gc_details = true;
          test = true;
          tidy = true;
          upgrade_dependency = true;
          vendor = true;
        };
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
    };
    svelte-language-server = {
      initialization_options = {
        configuration = {
          svelte = {
            plugin = {
              svelte = {
                format = {
                  enable = true;
                };
              };
              typescript = {
                enable = true;
              };
              css = {
                enable = true;
              };
              html = {
                enable = true;
              };
            };
          };
        };
      };
    };
  };

  vim = {
    toggle_relative_line_numbers = false;
    use_system_clipboard = "always";
    use_multiline_find = false;
    use_smartcase_find = true;
    highlight_on_yank_duration = 200;
    custom_digraphs = { };
  };
}
