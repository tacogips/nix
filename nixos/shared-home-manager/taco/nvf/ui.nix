{ mkLuaInline, ... }:
{
  settings.vim = {
    luaConfigRC.ui = ''
      vim.cmd.colorscheme("gruvbox")
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

      _G.vimrc = _G.vimrc or {}
      _G.vimrc.view = _G.vimrc.view or {}
      _G.vimrc.view.align_middle = function()
        local view = vim.fn.winsaveview()
        local win_width = vim.api.nvim_win_get_width(0)
        local cursor_col = vim.fn.virtcol(".") - 1
        view.leftcol = math.max(cursor_col - math.floor(win_width / 2), 0)
        vim.fn.winrestview(view)
      end
    '';

    statusline.lualine = {
      enable = true;
      theme = "gruvbox";
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
      inactiveSection = {
        a = [ ];
        b = [ ];
        c = [ "filename" ];
        x = [ "location" ];
        y = [ ];
        z = [ ];
      };
    };

    treesitter.highlight = {
      enable = true;
    };
  };
}
