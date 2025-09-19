{
  pkgs,
  lib,
  config,
  ...
}:

{
  # Disable the home-manager module since it's causing binary name conflicts
  programs.zed-editor.enable = false;

  # Add Zed directly to packages
  home.packages = with pkgs; [
    zed-editor
    nixfmt-rfc-style
    nil
  ];

  # Create mutable settings.json using home.file
  home.file.".config/zed/settings.json" = {
    force = true;
    mutable = true;
    text = builtins.toJSON {
      theme = {
        mode = "system";
        light = "One Dark";
        dark = "One Dark";
      };
      icon_theme = "Zed (Default)";
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
        version = "2";
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
          "command" = {
            "path" = "cratedocs-mcp";
            "args" = [ "stdio" ];
            "env" = { };
          };
        };

        "gitcodes-mcp" = {
          "command" = {
            "path" = "gitcodes-mcp";
            "args" = [ "stdio" ];
            "env" = { };
          };
        };

        "bravesearch-mcp" = {
          "command" = {
            "path" = "bravesearch-mcp";
            "args" = [ "stdio" ];
            "env" = { };
          };
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
            check = {
              command = "check";
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
    };
  };

  # Create keymap.json file
  xdg.configFile."zed/keymap.json".text = builtins.toJSON [
    {
      context = "Workspace";
      bindings = {
        "ctrl-p" = null;
        "ctrl-n" = null;
        "alt-m" = "terminal_panel::ToggleFocus";
        "alt-t" = "outline_panel::ToggleFocus";
        "alt-s" = "git_panel::ToggleFocus";
        "alt-a" = "agent::ToggleFocus";
        "alt-w" = "pane::RevealInProjectPanel";
        "alt-o" = "projects::OpenRecent";
        "alt-r" = "diagnostics::Deploy";
        "alt-g" = "workspace::ToggleZoom";
        "alt-e" = "project_panel::ToggleFocus";
      };
    }
    {
      context = "AgentPanel && not_editing";
      bindings = {
        ":" = "command_palette::Toggle";
      };
    }
    {
      context = "AgentPanel";
      bindings = {
        "ctrl-enter" = "assistant::Assist";
        "alt-ctrl-t" = "agent::NewTextThread";
        "ctrl-t" = "agent::NewThread";
        ", f" = "agent::OpenHistory";
        "escape" = "pane::GoBack";
      };
    }
    {
      context = "VimControl && !menu";
      bindings = {
        "ctrl-]" = "editor::OpenExcerpts";
        "shift-r" = null;
        ", g" = "editor::GoToDeclaration";
      };
    }
    {
      context = "GitPanel || ProjectPanel || CollabPanel || OutlinePanel || ChatPanel || VimControl || EmptyPane || SharedScreen || MarkdownPreview || KeyContextView";
      bindings = {
        "ctrl-w" = "pane::CloseActiveItem";
        "alt-j" = "workspace::ActivatePaneLeft";
        "alt-l" = "workspace::ActivatePaneRight";
        "alt-ctrl-t" = "pane::SplitVertical";
      };
    }
    {
      context = "ProjectPanel && not_editing";
      bindings = {
        ". y" = "workspace::OpenInTerminal";
        ", r" = "pane::DeploySearch";
        ":" = "command_palette::Toggle";
        "%" = "project_panel::NewFile";
        "/" = "project_panel::NewSearchInDirectory";
        ", ," = "file_finder::Toggle";
        "d" = "project_panel::NewDirectory";
        "ctrl-shift-d" = "project_panel::Delete";
        "enter" = "project_panel::OpenPermanent";
        "escape" = "project_panel::ToggleFocus";
        "h" = "project_panel::CollapseSelectedEntry";
        "j" = "menu::SelectNext";
        "k" = "menu::SelectPrevious";
        "l" = "project_panel::ExpandSelectedEntry";
        "o" = "project_panel::OpenPermanent";
        "y" = "workspace::CopyPath";
        "t" = "project_panel::OpenPermanent";
        "v" = "project_panel::OpenPermanent";
        "p" = "project_panel::Open";
        "x" = "project_panel::RevealInFileManager";
        "s" = "project_panel::OpenWithSystem";
        "] c" = "project_panel::SelectNextGitEntry";
        "[ c" = "project_panel::SelectPrevGitEntry";
        "] d" = "project_panel::SelectNextDiagnostic";
        "[ d" = "project_panel::SelectPrevDiagnostic";
        "}" = "project_panel::SelectNextDirectory";
        "{" = "project_panel::SelectPrevDirectory";
        "shift-g" = "menu::SelectLast";
        "g g" = "menu::SelectFirst";
        "-" = "project_panel::SelectParent";
        "ctrl-6" = "pane::AlternateFile";
      };
    }
    {
      context = "Editor";
      bindings = {
        "ctrl-shift-j" = "assistant::InlineAssist";
        "ctrl-shift-i" = "editor::Format";
      };
    }
    {
      context = "Editor && (showing_code_actions || showing_completions)";
      bindings = {
        "ctrl-p" = "editor::ContextMenuPrevious";
      };
    }
    {
      context = "vim_mode == normal";
      bindings = {
        ". y" = "workspace::OpenInTerminal";
        "y a" = "editor::CopyPath";
        "space w" = "workspace::Save";
        "space t" = "workspace::Reload";
        "space e" = "editor::ReloadFile";
        "space q" = "pane::CloseActiveItem";
        ", a" = "editor::ToggleCodeActions";
        ", e" = "editor::Rename";
        ", ," = "file_finder::Toggle";
        ", r" = "pane::DeploySearch";
        "r" = "vim::Search";
        ", n" = "editor::GoToDiagnostic";
        ", p" = "editor::GoToPreviousDiagnostic";
        ", y" = "editor::GoToTypeDefinition";
        ", z" = "editor::FindAllReferences";
        ", x" = "editor::GoToImplementation";
        ", t" = "editor::Hover";
      };
    }
    {
      context = "vim_mode == insert";
      bindings = {
        "ctrl-i" = "editor::Tab";
        "ctrl-shift-j" = "editor::ShowCompletions";
        "ctrl-shift-y" = "editor::ShowEditPrediction";
      };
    }
    {
      context = "ProjectSearchBar";
      bindings = {
        "ctrl-shift-f" = "search::FocusSearch";
        "ctrl-r" = "search::ToggleReplace";
        "ctrl-f" = "project_search::ToggleFilters";
        "ctrl-x" = "search::ToggleRegex";
      };
    }
    {
      context = "ProjectSearchView";
      bindings = {
        "escape" = "project_search::ToggleFocus";
        "ctrl-r" = "search::ToggleReplace";
        "ctrl-x" = "search::ToggleRegex";
      };
    }
    {
      context = "BufferSearchBar";
      bindings = {
        "escape" = "buffer_search::Dismiss";
        "tab" = "buffer_search::FocusEditor";
        "ctrl-r" = "search::ToggleReplace";
        "ctrl-l" = "search::ToggleSelection";
      };
    }
    {
      context = "Terminal";
      bindings = {
        "alt-ctrl-t" = "workspace::NewTerminal";
        "ctrl-w" = "pane::CloseActiveItem";
        "alt-s" = "terminal::ToggleViMode";
      };
    }
  ];

  # Create extensions.json file with all the extensions
  xdg.configFile."zed/extensions.json".text = builtins.toJSON [
    "html"
    "toml"
    "nix"
    "lua"
    "fish"
    "make"
    "git-firefly"
    "mcp-server-exa-search"
    "graphql"
    "dockerfile"
  ];
}
