{ pkgs, ... }:
{
  settings.vim.lazy.plugins."aerial.nvim" = {
    package = pkgs.vimPlugins.aerial-nvim;
    setupModule = "aerial";
    setupOpts = {
      backends = [
        "treesitter"
        "lsp"
        "markdown"
      ];
      layout = {
        max_width = [
          40
          0.35
        ];
        width = null;
        min_width = 10;
        default_direction = "prefer_right";
        placement = "window";
      };
      attach_mode = "window";
      close_automatic_events = [ ];
      default_bindings = true;
      disable_max_lines = 10000;
      disable_max_size = 2000000;
      filter_kind = [
        "Class"
        "Constructor"
        "Enum"
        "Function"
        "Interface"
        "Module"
        "Method"
        "Struct"
      ];
      highlight_mode = "split_width";
      highlight_closest = true;
      highlight_on_hover = false;
      highlight_on_jump = 300;
      icons = { };
      ignore = {
        unlisted_buffers = true;
        filetypes = [ ];
        buftypes = "special";
        wintypes = "special";
      };
      link_folds_to_tree = false;
      link_tree_to_folds = true;
      manage_folds = false;
      nerd_font = "true";
      on_attach = null;
      on_first_symbols = null;
      open_automatic = false;
      post_jump_cmd = "normal! zz";
      close_on_select = false;
      show_guides = false;
      update_events = "TextChanged,InsertLeave";
      guides = {
        mid_item = "├─";
        last_item = "└─";
        nested_top = "│ ";
        whitespace = "  ";
      };
      float = {
        border = "rounded";
        relative = "cursor";
        max_height = 0.9;
        height = null;
        min_height = [
          8
          0.1
        ];
      };
      lsp = {
        diagnostics_trigger_update = true;
        update_when_errors = true;
        update_delay = 300;
      };
      treesitter.update_delay = 300;
      markdown.update_delay = 300;
    };
  };
}
