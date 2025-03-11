{ pkgs, ... }:

{
  # Zed Editorの設定
  programs.zed-editor = {
    enable = true;
    #
    extraPackages = with pkgs; [
      nixfmt # Nix言語のフォーマッター
    ];

    # Zedエディタの設定を移行
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

      # 基本設定
      format_on_save = "on";
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;

      theme = {
        mode = "system";
        light = "One Dark";
        dark = "One Dark";
      };

      # アクティブペインの設定
      active_pane_modifiers = {
        magnification = 5;
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

    # 拡張機能のリスト
    extensions = [
      "html"
      "nix"
      "lua"
    ];

    # キーマップ設定
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-p" = null;
          "ctrl-shift-g" = "terminal_panel::ToggleFocus";
          "ctrl-shift-t" = "outline_panel::ToggleFocus";
          "ctrl-shift-a" = "assistant::ToggleFocus";
          ". y" = "workspace::OpenInTerminal";
          "alt-o" = "projects::OpenRecent";
          "alt-t" = null;
          "alt-r" = "diagnostics::Deploy";
        };
      }
      {
        context = "AssistantPanel";
        bindings = {
          "ctrl-t" = "assistant::NewContext";
          ", f" = "assistant::DeployHistory";
        };
      }
      {
        context = "Pane";
        bindings = { };
      }
      {
        context = "Editor";
        bindings = {
          "k j" = [
            "workspace::SendKeystrokes"
            "escape"
          ];
          "space n" = "editor::GoToDiagnostic";
          "space p" = "editor::GoToPrevDiagnostic";
          ". a" = "editor::ToggleCodeActions";
          "ctrl-k" = "assistant::InlineAssist";
          "ctrl-a" = "editor::ShowCompletions";
        };
      }
      {
        context = "Editor && (showing_code_actions || showing_completions)";
        bindings = {
          "ctrl-p" = "editor::ContextMenuPrev";
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
          "alt-t" = "pane::SplitVertical";
          "alt-m" = "vim::MaximizePane";
        };
      }
      {
        context = "ProjectPanel";
        bindings = { };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          ":" = "command_palette::Toggle";
          "%" = "project_panel::NewFile";
          "r" = "project_panel::NewSearchInDirectory";
          "/" = "file_finder::Toggle";
          "shift-d" = "project_panel::RemoveFromProject";
          "enter" = "project_panel::OpenPermanent";
          "escape" = "project_panel::ToggleFocus";
          "h" = "project_panel::CollapseSelectedEntry";
          "j" = "menu::SelectNext";
          "k" = "menu::SelectPrev";
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
        context = "vim_mode == normal";
        bindings = {
          "space w" = "workspace::Save";
          "space q" = [
            "pane::CloseActiveItem"
            { close_pinned = false; }
          ];
          ", ," = "file_finder::Toggle";
          ", g" = "pane::DeploySearch";
          "r" = "vim::Search";
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
          "alt-t" = "workspace::NewTerminal";
          "ctrl-w" = "pane::CloseActiveItem";
        };
      }
    ];

  };

}
