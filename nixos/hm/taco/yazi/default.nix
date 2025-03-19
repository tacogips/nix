{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;

    # シェルラッパー名の設定（デフォルトはyy）
    shellWrapperName = "y";

    # シェル統合の有効化
    enableFishIntegration = true;

    #keymap = {
    #  input.prepend_keymap = [
    #    {
    #      run = "close";
    #      on = [ "<C-q>" ];
    #    }
    #    {
    #      run = "close --submit";
    #      on = [ "<Enter>" ];
    #    }
    #    {
    #      run = "escape";
    #      on = [ "<Esc>" ];
    #    }
    #    {
    #      run = "backspace";
    #      on = [ "<Backspace>" ];
    #    }
    #  ];

    #  manager.prepend_keymap = [
    #    {
    #      run = "escape";
    #      on = [ "<Esc>" ];
    #    }
    #    {
    #      run = "quit";
    #      on = [ "q" ];
    #    }
    #    {
    #      run = "close";
    #      on = [ "<C-q>" ];
    #    }
    #    {
    #      run = "open";
    #      on = [ "<Enter>" ];
    #    }
    #    {
    #      run = "parent";
    #      on = [ "h" ];
    #    }
    #    {
    #      run = "cd";
    #      on = [ "l" ];
    #    }
    #    {
    #      run = "up";
    #      on = [ "k" ];
    #    }
    #    {
    #      run = "down";
    #      on = [ "j" ];
    #    }
    #  ];

    #  preview.prepend_keymap = [
    #    {
    #      run = "toggle";
    #      on = [ "<Tab>" ];
    #    }
    #  ];
    #};

    settings = {
    };

    #theme = {
    #  filetype = {
    #    rules = [
    #      {
    #        fg = "#7AD9E5";
    #        mime = "image/*";
    #      }
    #      {
    #        fg = "#F3D398";
    #        mime = "video/*";
    #      }
    #      {
    #        fg = "#F3D398";
    #        mime = "audio/*";
    #      }
    #      {
    #        fg = "#CD9EFC";
    #        mime = "application/zip";
    #      }
    #      {
    #        fg = "#CD9EFC";
    #        mime = "application/gzip";
    #      }
    #      {
    #        fg = "#CD9EFC";
    #        mime = "application/x-tar";
    #      }
    #      {
    #        fg = "#85C46C";
    #        mime = "text/*";
    #      }
    #      {
    #        fg = "#7AD9E5";
    #        mime = "application/pdf";
    #      }
    #    ];
    #  };

    #  status = {
    #    separator_open = "";
    #    separator_close = "";
    #  };

    #  selection = {
    #    fg = "#000000";
    #    bg = "#FFFFFF";
    #  };

    #  current = {
    #    fg = "#1E1E1E";
    #    bg = "#EEEEEE";
    #  };
    #};

    #initLua = ''
    #  function Status:name()
    #    local h = cx.active.current.hovered
    #    if h == nil then
    #      return ui.Span("")
    #    end

    #    local linked = ""
    #    if h.link_to ~= nil then
    #      linked = " -> " .. h.link_to
    #    end

    #    return ui.Span(" " .. h.name .. linked)
    #  end
    #'';

    #initLua = ./init.lua;

    #plugins = {
    #  # 例: yaziが提供するステータスライン拡張
    #  "statusline" = pkgs.fetchFromGitHub {
    #    owner = "yazi-rs";
    #    repo = "plugin-statusline";
    #    rev = "v0.1.0";
    #    sha256 = "sha256-aBcDeFgHiJkLmNoPqRsTuVwXyZ..."; # ハッシュを適切に設定してください
    #  };
    #};

    #flavors = {
    #  # 例: 既存のダークテーマを追加
    #  "dracula" = pkgs.fetchFromGitHub {
    #    owner = "yazi-rs";
    #    repo = "theme-dracula";
    #    rev = "v1.0.0";
    #    sha256 = "sha256-AbCdEfGhIjKlMnOpQrStUvWxYz..."; # ハッシュを適切に設定してください
    #  };
    #};
  };
}
