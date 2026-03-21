{ ... }:
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
      action = "<Nop>";
    }
    {
      # Disable Ex mode entry.
      mode = "n";
      key = "gQ";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling Ex formatting.
      mode = "n";
      key = "gq";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling bracket jumps here.
      mode = "n";
      key = "g%";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling external open.
      mode = "n";
      key = "gx";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling line start motion.
      mode = "n";
      key = "g0";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling UTF-8 inspection.
      mode = "n";
      key = "g8";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling ASCII inspection.
      mode = "n";
      key = "ga";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling last non-blank motion.
      mode = "n";
      key = "g^";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling last non-blank motion.
      mode = "n";
      key = "g_";
      action = "<Nop>";
    }
    {
      # Keep `g` focused on custom goto mappings by disabling case toggle.
      mode = "n";
      key = "g~";
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
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling recursive fold toggle.
      mode = "n";
      key = "zA";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold open.
      mode = "n";
      key = "zo";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling recursive fold open.
      mode = "n";
      key = "zO";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold reduction.
      mode = "n";
      key = "zr";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold increase.
      mode = "n";
      key = "zi";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold creation.
      mode = "n";
      key = "zf";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling fold mark.
      mode = "n";
      key = "zF";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling spell suggestion.
      mode = "n";
      key = "z=";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling screen-line top motion.
      mode = "n";
      key = "z^";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling redraw to cursor line.
      mode = "n";
      key = "z.";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling top scroll shortcut.
      mode = "n";
      key = "z+";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling put with trailing indent.
      mode = "n";
      key = "zp";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling put with leading indent.
      mode = "n";
      key = "zP";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient width fit.
      mode = "n";
      key = "zw";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient width fit.
      mode = "n";
      key = "zW";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient text width.
      mode = "n";
      key = "zx";
      action = "<Nop>";
    }
    {
      # Keep `z` focused on custom view mappings by disabling transient text width.
      mode = "n";
      key = "zX";
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
      # Copy the current working directory to the system clipboard.
      mode = "n";
      key = "<Space>c";
      desc = "Copy current directory path";
      action = ":let @+=getcwd()<CR>";
    }
    {
      # Insert a newline below and return to normal mode.
      mode = "n";
      key = "<Space>j";
      desc = "Insert newline below";
      action = "i<CR><ESC>";
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
      # Run the current buffer through QuickRun.
      mode = "n";
      key = "<Space>R";
      desc = "Run current file with QuickRun";
      action = ":QuickRun<CR>";
    }
    {
      # Open the Aerial symbol picker through Telescope.
      mode = "n";
      key = "<Space>t";
      desc = "Open Aerial symbol picker";
      action = "<cmd>Telescope aerial<CR>";
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
      # Copy the current file path to the system clipboard.
      mode = "n";
      key = "<Space>C";
      desc = "Copy current file path";
      action = ":let @+=expand('%:p')<CR>";
    }
    {
      # Helix-like `Space g`: show changed files / git status entries in Telescope.
      mode = "n";
      key = "<Space>g";
      desc = "Open git status picker";
      action = "<CMD>lua require'telescope.builtin'.git_status{}<Cr>";
    }
    {
      # Helix-like `Space G`: list git branches in Telescope.
      mode = "n";
      key = "<Space>G";
      desc = "Open git branch picker";
      action = "<CMD>lua require'telescope.builtin'.git_branches{}<Cr>";
    }
    {
      # Helix-like `Space g c`: show commit history in Telescope.
      mode = "n";
      key = "<Space>gc";
      desc = "Open git commit picker";
      action = "<CMD>lua require'telescope.builtin'.git_commits{}<Cr>";
    }
    {
      # Helix-like `Space '`: reopen the last fuzzy picker context via recent files.
      mode = "n";
      key = "<Space>'";
      desc = "Open recent files picker";
      action = "<CMD>:Telescope oldfiles<Cr>";
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
      # Helix-like `Space /`: search text across the project.
      mode = "n";
      key = "<Space>/";
      desc = "Open live grep picker";
      action = "<CMD>lua require'telescope.builtin'.live_grep{}<Cr>";
    }
    {
      # Helix-like `Space m`: show marks in Telescope.
      mode = "n";
      key = "<Space>m";
      desc = "Open marks picker";
      action = "<CMD>lua require'telescope.builtin'.marks{}<Cr>";
    }
    {
      # Helix-like `Space h`: show command-line history in Telescope.
      mode = "n";
      key = "<Space>h";
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
      desc = "Show code actions";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    }
    {
      # Helix-like `Space S`: show workspace-wide LSP symbols.
      mode = "n";
      key = "<Space>S";
      desc = "Open workspace symbols picker";
      action = "<CMD>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<Cr>";
    }
    {
      # Helix-like `Space s`: show document-local symbols through Telescope.
      mode = "n";
      key = "<Space>s";
      desc = "Open document symbols picker";
      action = "<CMD>lua require'telescope.builtin'.lsp_document_symbols{}<Cr>";
    }
    {
      # Helix-like `Space d`: show document diagnostics through Telescope.
      mode = "n";
      key = "<Space>d";
      desc = "Open document diagnostics picker";
      action = "<CMD>lua require'telescope.builtin'.diagnostics{bufnr=0}<Cr>";
    }
    {
      # Helix-like `Space D`: show workspace diagnostics through Telescope.
      mode = "n";
      key = "<Space>D";
      desc = "Open workspace diagnostics picker";
      action = "<CMD>lua require'telescope.builtin'.diagnostics{}<Cr>";
    }
    {
      # Go-style `g n`: jump to the next diagnostic.
      mode = "n";
      key = "gn";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    }
    {
      # Go-style `g p`: jump to the previous diagnostic.
      mode = "n";
      key = "gp";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    }
    {
      # Helix-like `Space k`: show hover documentation from the LSP server.
      mode = "n";
      key = "<Space>k";
      desc = "Show hover documentation";
      action = "<Cmd>lua vim.lsp.buf.hover()<CR>";
    }
    {
      # Helix-like `Space r`: rename the symbol under the cursor.
      mode = "n";
      key = "<Space>r";
      desc = "Rename symbol";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
    }
    {
      # Helix-like `g d`: jump to the symbol definition.
      mode = "n";
      key = "gd";
      desc = "Jump to definition";
      action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
    }
    {
      # Helix-like `g y`: jump to the type definition.
      mode = "n";
      key = "gy";
      desc = "Jump to type definition";
      action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
    }
    {
      # Helix-like `g r`: show references through Telescope.
      mode = "n";
      key = "gr";
      desc = "Open references picker";
      action = "<CMD>lua require'telescope.builtin'.lsp_references{}<Cr>";
    }
    {
      # Helix-like `g i`: show implementations through Telescope.
      mode = "n";
      key = "gi";
      desc = "Open implementations picker";
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
