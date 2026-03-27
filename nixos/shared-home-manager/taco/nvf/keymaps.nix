{ chillaCommand, ... }:
{
  # Prefix grouping rule for custom keymaps in this repo:
  # - `<Space>` is the main picker/action namespace.
  # - `g` is the goto/jump namespace.
  # - `m` is the match/surround/textobject namespace.
  # - mappings without those prefixes are reserved for basic editing ergonomics.
  # Some historical or low-level exceptions remain, such as `Q`/`gQ`, `<Esc><Esc>`,
  # Ctrl-based diagnostic shortcuts, insert/visual `kj` escape mappings, and the
  # Helix-like `z` view-mode aliases below.
  settings.vim.keymaps = [
    {
      # Cancel the current command-line input.
      mode = "c";
      key = "<C-g>";
      action = "<C-c>";
    }
    {
      # Move to the beginning of the command line.
      mode = "c";
      key = "<C-a>";
      action = "<C-b>";
    }
    {
      # Delete the character under the cursor while staying in insert mode.
      mode = "i";
      key = "<C-d>";
      action = "<Delete>";
    }
    {
      # Backspace in insert mode.
      mode = "i";
      key = "<C-h>";
      action = "<Bs>";
    }
    {
      # Move right in insert mode.
      mode = "i";
      key = "<C-f>";
      action = "<Right>";
    }
    {
      # Move left in insert mode.
      mode = "i";
      key = "<C-b>";
      action = "<Left>";
    }
    {
      # Leave insert mode without reaching for Escape.
      mode = "i";
      key = "kj";
      action = "<ESC><ESC>";
    }
    {
      # Paste from the system clipboard in insert mode.
      mode = "i";
      key = "<C-v>";
      action = "<C-R>+";
    }
    {
      # Leave insert mode and turn off IME input.
      mode = "i";
      key = "<ESC>";
      action = "<ESC>:set iminsert=0<CR>";
    }
    {
      # Keep Ctrl-j free from its default insert-mode meaning.
      mode = "i";
      key = "<C-j>";
      desc = "-";
      action = "<nop>";
    }
    {
      # Trigger completion with LSP-aware sources on demand.
      mode = "i";
      key = "<C-a>";
      action = "<Cmd>lua vimrc.cmp.lsp()<CR>";
    }
    {
      # Disable Ex mode entry.
      mode = "n";
      key = "Q";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Disable Ex mode entry.
      mode = "n";
      key = "gQ";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling Ex formatting.
      mode = "n";
      key = "gq";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling bracket jumps here.
      mode = "n";
      key = "g%";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling external open.
      mode = "n";
      key = "gx";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling line start motion.
      mode = "n";
      key = "g0";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling UTF-8 inspection.
      mode = "n";
      key = "g8";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling ASCII inspection.
      mode = "n";
      key = "ga";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling last non-blank motion.
      mode = "n";
      key = "g^";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling last non-blank motion.
      mode = "n";
      key = "g_";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling case toggle.
      mode = "n";
      key = "g~";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Clear search highlighting.
      mode = "n";
      key = "<Esc><Esc>";
      action = ":set nohlsearch<CR>";
    }
    {
      # Move by screen lines instead of file lines.
      mode = "n";
      key = "k";
      action = "gk";
    }
    {
      # Jump back to the previous change.
      mode = "n";
      key = "+";
      action = "g;";
    }
    {
      # Join lines without inserting extra whitespace.
      mode = "n";
      key = "J";
      action = "gJ";
    }
    {
      # Helix-like `z c`: vertically center the current line.
      mode = "n";
      key = "zc";
      desc = "Center current line";
      action = "zz";
    }
    {
      # Helix-like `z j`: scroll the view downward without moving the cursor.
      mode = "n";
      key = "zj";
      desc = "Scroll view down";
      action = "<C-e>";
    }
    {
      # Helix-like `z k`: scroll the view upward without moving the cursor.
      mode = "n";
      key = "zk";
      desc = "Scroll view up";
      action = "<C-y>";
    }
    {
      # Helix-like `z m`: align the cursor near the horizontal middle of the window.
      mode = "n";
      key = "zm";
      desc = "Center cursor horizontally";
      action = "<Cmd>lua vimrc.view.align_middle()<CR>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold toggle.
      mode = "n";
      key = "za";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling recursive fold toggle.
      mode = "n";
      key = "zA";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold open.
      mode = "n";
      key = "zo";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling recursive fold open.
      mode = "n";
      key = "zO";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold reduction.
      mode = "n";
      key = "zr";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold increase.
      mode = "n";
      key = "zi";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold creation.
      mode = "n";
      key = "zf";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold mark.
      mode = "n";
      key = "zF";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling spell suggestion.
      mode = "n";
      key = "z=";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling screen-line top motion.
      mode = "n";
      key = "z^";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling redraw to cursor line.
      mode = "n";
      key = "z.";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling top scroll shortcut.
      mode = "n";
      key = "z+";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling put with trailing indent.
      mode = "n";
      key = "zp";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling put with leading indent.
      mode = "n";
      key = "zP";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient width fit.
      mode = "n";
      key = "zw";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient width fit.
      mode = "n";
      key = "zW";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient text width.
      mode = "n";
      key = "zx";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient text width.
      mode = "n";
      key = "zX";
      desc = "-";
      action = "<Nop>";
    }
    {
      # Helix-like `m m`: jump to the matching bracket.
      mode = "n";
      key = "mm";
      desc = "Jump to matching bracket";
      action = "%";
    }
    {
      # Helix-like `m s`: start a surround add with vim-surround's `ys`.
      mode = "n";
      key = "ms";
      desc = "Add surround";
      action = "ys";
    }
    {
      # Helix-like `m r`: start a surround replace with vim-surround's `cs`.
      mode = "n";
      key = "mr";
      desc = "Replace surround";
      action = "cs";
    }
    {
      # Helix-like `m d`: start a surround delete with vim-surround's `ds`.
      mode = "n";
      key = "md";
      desc = "Delete surround";
      action = "ds";
    }
    {
      # Helix-like `m a`: start an around-textobject visual selection.
      mode = "n";
      key = "ma";
      desc = "Select around textobject";
      action = "va";
    }
    {
      # Helix-like `m i`: start an inside-textobject visual selection.
      mode = "n";
      key = "mi";
      desc = "Select inside textobject";
      action = "vi";
    }
    {
      # Reload the current buffer from disk.
      mode = "n";
      key = "<Space>.";
      desc = "Reload file from disk";
      action = ":e! %<CR>";
    }
    {
      # Save the current buffer.
      mode = "n";
      key = "<Space>w";
      desc = "Write current file";
      action = ":write<CR>";
    }
    {
      # Copy the current file path to the system clipboard.
      mode = "n";
      key = "<Space>c";
      desc = "Copy current file path";
      action = ":let @+=expand('%:p')<CR>";
    }
    {
      # Helix-like `Space j`: open the jumplist in Telescope.
      mode = "n";
      key = "<Space>j";
      desc = "Open jump history picker";
      action = "<CMD>lua require'telescope.builtin'.jumplist{}<Cr>";
    }
    {
      # Force-quit the current window.
      mode = "n";
      key = "<Space><Space>q";
      desc = "Force-quit current window";
      action = ":q!<CR>";
    }
    {
      # Open yazi in the current working directory.
      mode = "n";
      key = "<Space>e";
      desc = "Open yazi file browser";
      action = ":Yazi cwd<CR>";
    }
    {
      # Open the current file, or fall back to the current working directory, in Chilla.
      mode = "n";
      key = "<Space>v";
      desc = "Open current file or directory in Chilla";
      action = "<Cmd>lua local path = vim.api.nvim_buf_get_name(0); if path == '' then path = vim.fn.getcwd() else path = vim.fn.fnamemodify(path, ':p') end; vim.fn.jobstart({ '${chillaCommand}', path }, { detach = true })<CR>";
    }
    {
      # Run the current buffer through QuickRun.
      mode = "n";
      key = "<Space>R";
      desc = "Run current file with QuickRun";
      action = ":QuickRun<CR>";
    }
    {
      # Helix-like `Space p`: paste the system clipboard after the cursor.
      mode = "n";
      key = "<Space>p";
      desc = "Paste system clipboard after";
      action = "\"+p";
    }
    {
      # Helix-like `Space p`: paste the system clipboard over the selection.
      mode = "v";
      key = "<Space>p";
      desc = "Paste system clipboard after";
      action = "\"+p";
    }
    {
      # Helix-like `Space P`: paste the system clipboard before the cursor.
      mode = "n";
      key = "<Space>P";
      desc = "Paste system clipboard before";
      action = "\"+P";
    }
    {
      # Helix-like `Space P`: paste the system clipboard before the selection.
      mode = "v";
      key = "<Space>P";
      desc = "Paste system clipboard before";
      action = "\"+P";
    }
    {
      # Helix-like `Space y`: start a yank to the system clipboard.
      mode = "n";
      key = "<Space>y";
      desc = "Yank to system clipboard";
      action = "\"+y";
    }
    {
      # Helix-like `Space y`: yank the selection to the system clipboard.
      mode = "v";
      key = "<Space>y";
      desc = "Yank to system clipboard";
      action = "\"+y";
    }
    {
      # Helix-like `Space Y`: yank the current line to the system clipboard.
      mode = "n";
      key = "<Space>Y";
      desc = "Yank line to system clipboard";
      action = "\"+Y";
    }
    {
      # Copy the current working directory to the system clipboard.
      mode = "n";
      key = "<Space>C";
      desc = "Copy current directory path";
      action = ":let @+=getcwd()<CR>";
    }
    {
      # Helix-like `Space g`: open LazyGit in a floating window.
      mode = "n";
      key = "<Space>g";
      desc = "Open LazyGit";
      action = "<CMD>LazyGit<CR>";
    }
    {
      # Helix-like `Space G`: list git branches in Telescope.
      mode = "n";
      key = "<Space>G";
      desc = "Open git branch picker";
      action = "<CMD>lua require'telescope.builtin'.git_branches{}<Cr>";
    }
    {
      # Helix-like `Space ,`: open a smart file picker across history, buffers, and cwd files.
      mode = "n";
      key = "<Space>,";
      desc = "Open smart file picker";
      action = "<CMD>lua taco_smart_open()<Cr>";
    }
    {
      # Helix-like `Space b`: pick from open buffers.
      mode = "n";
      key = "<Space>b";
      desc = "Open buffer picker";
      action = "<CMD>lua require'telescope.builtin'.buffers{}<CR>";
    }
    {
      # Helix-like `Space f`: search tracked files in the current git repo.
      mode = "n";
      key = "<Space>f";
      desc = "Open git files picker";
      action = "<CMD>lua require'telescope.builtin'.git_files{}<Cr>";
    }
    {
      # Helix-like `Space /`: search tracked files in the current git repo, or the cwd otherwise.
      mode = "n";
      key = "<Space>/";
      desc = "Open repo-aware grep picker";
      action = "<CMD>lua taco_project_live_grep()<Cr>";
    }
    {
      # Helix-like `Space m`: show marks in Telescope.
      mode = "n";
      key = "<Space>m";
      desc = "Open marks picker";
      action = "<CMD>lua require'telescope.builtin'.marks{}<Cr>";
    }
    {
      # Helix-like `Space H`: show command-line history in Telescope.
      mode = "n";
      key = "<Space>H";
      desc = "Open command history picker";
      action = "<CMD>lua require'telescope.builtin'.command_history{}<Cr>";
    }
    {
      # Helix-like `Space ?`: show active keymaps in Telescope.
      mode = "n";
      key = "<Space>?";
      desc = "Open keymap picker";
      action = "<CMD>lua require'telescope.builtin'.keymaps{}<Cr>";
    }
    {
      # Helix-like `Space a`: show available LSP code actions.
      mode = "n";
      key = "<Space>a";
      desc = "[lsp] Show code actions";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    }
    {
      # Helix-like `Space s`: show only struct-like symbols from the workspace.
      mode = "n";
      key = "<Space>s";
      desc = "[lsp] Open workspace type symbols picker";
      action = "<CMD>lua taco_workspace_struct_symbols()<Cr>";
    }
    {
      # Helix-like `Space S`: show workspace symbols except struct-like symbols.
      mode = "n";
      key = "<Space>S";
      desc = "[lsp] Open workspace non-type symbols picker";
      action = "<CMD>lua taco_workspace_non_struct_symbols()<Cr>";
    }
    {
      # Helix-like `Space W`: show all workspace symbols without filtering.
      mode = "n";
      key = "<Space>W";
      desc = "[lsp] Open workspace symbols picker";
      action = "<CMD>lua taco_workspace_symbols()<Cr>";
    }
    {
      # Helix-like `Space t`: show document-local symbols through Telescope.
      mode = "n";
      key = "<Space>t";
      desc = "[lsp] Open document symbols picker";
      action = "<CMD>lua require'telescope.builtin'.lsp_document_symbols{}<Cr>";
    }
    {
      # Helix-like `Space d`: show document diagnostics through Telescope.
      mode = "n";
      key = "<Space>d";
      desc = "[lsp] Open document diagnostics picker";
      action = "<CMD>lua require'telescope.builtin'.diagnostics{bufnr=0}<Cr>";
    }
    {
      # Helix-like `Space D`: show workspace diagnostics through Telescope.
      mode = "n";
      key = "<Space>D";
      desc = "[lsp] Open workspace diagnostics picker";
      action = "<CMD>lua require'telescope.builtin'.diagnostics{}<Cr>";
    }
    {
      # Go-style `g n`: jump to the next diagnostic.
      mode = "n";
      key = "gn";
      desc = "[lsp] Jump to next diagnostic";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    }
    {
      # Go-style `g p`: jump to the previous diagnostic.
      mode = "n";
      key = "gp";
      desc = "[lsp] Jump to previous diagnostic";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    }
    {
      # Helix-like `Space k`: show hover documentation from the LSP server.
      mode = "n";
      key = "<Space>k";
      desc = "[lsp] Show hover documentation";
      action = "<Cmd>lua vim.lsp.buf.hover()<CR>";
    }
    {
      # Helix-like `Space r`: rename the symbol under the cursor.
      mode = "n";
      key = "<Space>r";
      desc = "[lsp] Rename symbol";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
    }
    {
      # Helix-like `g d`: jump to the symbol definition.
      mode = "n";
      key = "gd";
      desc = "[lsp] Jump to definition";
      action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
    }
    {
      # Helix-like `g y`: jump to the type definition.
      mode = "n";
      key = "gy";
      desc = "[lsp] Jump to type definition";
      action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
    }
    {
      # Helix-like `g r`: show references through Telescope.
      mode = "n";
      key = "gr";
      desc = "[lsp] Open references picker";
      action = "<CMD>lua require'telescope.builtin'.lsp_references{}<Cr>";
    }
    {
      # Helix-like `g i`: show implementations through Telescope.
      mode = "n";
      key = "gi";
      desc = "[lsp] Open implementations picker";
      action = "<CMD>lua require'telescope.builtin'.lsp_implementations{}<Cr>";
    }
    {
      # Jump to the previous diagnostic.
      mode = "n";
      key = "<C-s>";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    }
    {
      # Jump to the next diagnostic.
      mode = "n";
      key = "<C-g>";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    }
    {
      # Restart the active LSP clients.
      mode = "n";
      key = "<Space>\\";
      desc = "[lsp] Restart LSP";
      action = ":LspRestart<CR>";
    }
    {
      # Leave visual mode without reaching for Escape.
      mode = "v";
      key = "kj";
      action = "<ESC><ESC>";
    }
    {
      # Helix-like `g j`: jump to any single-character target with Hop.
      mode = "n";
      key = "gj";
      desc = "Hop jump anywhere";
      action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
    }
    {
      # Helix-like `g j`: jump to any single-character target with Hop.
      mode = "v";
      key = "gj";
      desc = "Hop jump anywhere";
      action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
    }
    {
      # Helix-like `g f`: jump to a single-character target on the current line with Hop.
      mode = "n";
      key = "gf";
      desc = "Hop jump on current line";
      action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
    }
    {
      # Helix-like `g f`: jump to a single-character target on the current line with Hop.
      mode = "v";
      key = "gf";
      desc = "Hop jump on current line";
      action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
    }
  ];
}
