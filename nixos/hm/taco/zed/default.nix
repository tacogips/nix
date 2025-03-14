{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      nixfmt
      nil
    ];

    userSettings = {
      # Assistantの設定
      assistant = {
        default_model = {
          provider = "anthropic";
          model = "claude-3-7-sonnet-latest";
        };
        version = "2";
      };

      telemetry = {
        diagnostics = false;
      };

      format_on_save = "on";
      vim_mode = true;
      ui_font_size = 12;
      buffer_font_size = 12;
      font_famity = "iosevka";

      theme = {
        mode = "system";
        light = "One Dark";
        dark = "One Dark";
      };

      active_pane_modifiers = {
        magnification = 1.5;
        border_size = 2.0;
        inactive_opacity = 0.3;
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

    extensions = [
      "html"
      "nix"
      "lua"
      "fish"
    ];

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-p" = null;
          "ctrl-n" = null;
          "alt-m" = "terminal_panel::ToggleFocus";
          "alt-t" = "outline_panel::ToggleFocus";
          "alt-a" = "assistant::ToggleFocus";
          "alt-o" = "projects::OpenRecent";
          "alt-r" = "diagnostics::Deploy";
          "alt-g" = "workspace::ToggleZoom";
          "alt-e" = "project_panel::ToggleFocus";
          "alt-j" = "pane::RevealInProjectPanel";
        };
      }
      {
        context = "AssistantPanel";
        bindings = {
          "ctrl-t" = "assistant::NewChat";
          ", f" = "assistant::DeployHistory";
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
          ":" = "command_palette::Toggle";
          "%" = "project_panel::NewFile";
          "r" = "project_panel::NewSearchInDirectory";
          "/" = "file_finder::Toggle";
          "d" = "project_panel::NewDirectory";
          "shift-d" = "project_panel::RemoveFromProject";
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
          "ctrl-k" = "assistant::InlineAssist";
          "ctrl-a" = "editor::ShowCompletions";
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
          "space w" = "workspace::Save";
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
        };
      }
      {
        context = "ProjectSearchBar";
        bindings = {
          "shift-f" = "search::FocusSearch";
          "ctrl-f" = "project_search::ToggleFilters";
        };
      }
      {
        context = "ProjectSearchView";
        bindings = {
          "escape" = "project_search::ToggleFocus";
          "ctrl-shift-h" = "search::ToggleReplace";
          "alt-ctrl-g" = "search::ToggleRegex";
          "alt-ctrl-x" = "search::ToggleRegex";
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
  };
}
