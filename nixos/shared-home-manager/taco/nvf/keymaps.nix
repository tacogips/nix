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
      action = "zz";
    }
    {
      # Helix-like `z j`: scroll the view downward without moving the cursor.
      mode = "n";
      key = "zj";
      action = "<C-e>";
    }
    {
      # Helix-like `z k`: scroll the view upward without moving the cursor.
      mode = "n";
      key = "zk";
      action = "<C-y>";
    }
    {
      # Helix-like `z m`: align the cursor near the horizontal middle of the window.
      mode = "n";
      key = "zm";
      action = "<Cmd>lua vimrc.view.align_middle()<CR>";
    }
    {
      # Helix-like `m m`: jump to the matching bracket.
      mode = "n";
      key = "mm";
      action = "%";
    }
    {
      # Helix-like `m s`: start a surround add with vim-surround's `ys`.
      mode = "n";
      key = "ms";
      action = "ys";
    }
    {
      # Helix-like `m r`: start a surround replace with vim-surround's `cs`.
      mode = "n";
      key = "mr";
      action = "cs";
    }
    {
      # Helix-like `m d`: start a surround delete with vim-surround's `ds`.
      mode = "n";
      key = "md";
      action = "ds";
    }
    {
      # Helix-like `m a`: start an around-textobject visual selection.
      mode = "n";
      key = "ma";
      action = "va";
    }
    {
      # Helix-like `m i`: start an inside-textobject visual selection.
      mode = "n";
      key = "mi";
      action = "vi";
    }
    {
      # Reload the current buffer from disk.
      mode = "n";
      key = "<Space>.";
      action = ":e! %<CR>";
    }
    {
      # Save the current buffer.
      mode = "n";
      key = "<Space>w";
      action = ":write<CR>";
    }
    {
      # Copy the current working directory to the system clipboard.
      mode = "n";
      key = "<Space>c";
      action = ":let @+=getcwd()<CR>";
    }
    {
      # Insert a newline below and return to normal mode.
      mode = "n";
      key = "<Space>j";
      action = "i<CR><ESC>";
    }
    {
      # Open yazi in the current working directory.
      mode = "n";
      key = "<Space>e";
      action = ":Yazi cwd<CR>";
    }
    {
      # Run the current buffer through QuickRun.
      mode = "n";
      key = "<Space>R";
      action = ":QuickRun<CR>";
    }
    {
      # Open the Aerial symbol picker through Telescope.
      mode = "n";
      key = "<Space>t";
      action = "<cmd>Telescope aerial<CR>";
    }
    {
      # Helix-like `Space p`: paste the system clipboard after the cursor.
      mode = "n";
      key = "<Space>p";
      action = "\"+p";
    }
    {
      # Helix-like `Space p`: paste the system clipboard over the selection.
      mode = "v";
      key = "<Space>p";
      action = "\"+p";
    }
    {
      # Helix-like `Space P`: paste the system clipboard before the cursor.
      mode = "n";
      key = "<Space>P";
      action = "\"+P";
    }
    {
      # Helix-like `Space P`: paste the system clipboard before the selection.
      mode = "v";
      key = "<Space>P";
      action = "\"+P";
    }
    {
      # Helix-like `Space y`: start a yank to the system clipboard.
      mode = "n";
      key = "<Space>y";
      action = "\"+y";
    }
    {
      # Helix-like `Space y`: yank the selection to the system clipboard.
      mode = "v";
      key = "<Space>y";
      action = "\"+y";
    }
    {
      # Helix-like `Space Y`: yank the current line to the system clipboard.
      mode = "n";
      key = "<Space>Y";
      action = "\"+Y";
    }
    {
      # Copy the current file path to the system clipboard.
      mode = "n";
      key = "<Space>C";
      action = ":let @+=expand('%:p')<CR>";
    }
    {
      # Helix-like `Space g`: show changed files / git status entries in Telescope.
      mode = "n";
      key = "<Space>g";
      action = "<CMD>lua require'telescope.builtin'.git_status{}<Cr>";
    }
    {
      # Helix-like `Space G`: list git branches in Telescope.
      mode = "n";
      key = "<Space>G";
      action = "<CMD>lua require'telescope.builtin'.git_branches{}<Cr>";
    }
    {
      # Helix-like `Space g c`: show commit history in Telescope.
      mode = "n";
      key = "<Space>gc";
      action = "<CMD>lua require'telescope.builtin'.git_commits{}<Cr>";
    }
    {
      # Helix-like `Space '`: reopen the last fuzzy picker context via recent files.
      mode = "n";
      key = "<Space>'";
      action = "<CMD>:Telescope oldfiles<Cr>";
    }
    {
      # Helix-like `Space b`: pick from open buffers.
      mode = "n";
      key = "<Space>b";
      action = "<CMD>lua require'telescope.builtin'.buffers{}<CR>";
    }
    {
      # Helix-like `Space f`: search tracked files in the current git repo.
      mode = "n";
      key = "<Space>f";
      action = "<CMD>lua require'telescope.builtin'.git_files{}<Cr>";
    }
    {
      # Helix-like `Space /`: search text across the project.
      mode = "n";
      key = "<Space>/";
      action = "<CMD>lua require'telescope.builtin'.live_grep{}<Cr>";
    }
    {
      # Helix-like `Space m`: show marks in Telescope.
      mode = "n";
      key = "<Space>m";
      action = "<CMD>lua require'telescope.builtin'.marks{}<Cr>";
    }
    {
      # Helix-like `Space h`: show command-line history in Telescope.
      mode = "n";
      key = "<Space>h";
      action = "<CMD>lua require'telescope.builtin'.command_history{}<Cr>";
    }
    {
      # Helix-like `Space ?`: show active keymaps in Telescope.
      mode = "n";
      key = "<Space>?";
      action = "<CMD>lua require'telescope.builtin'.keymaps{}<Cr>";
    }
    {
      # Helix-like `Space a`: show available LSP code actions.
      mode = "n";
      key = "<Space>a";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    }
    {
      # Helix-like `Space S`: show workspace-wide LSP symbols.
      mode = "n";
      key = "<Space>S";
      action = "<CMD>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<Cr>";
    }
    {
      # Helix-like `Space s`: show document-local symbols through Telescope.
      mode = "n";
      key = "<Space>s";
      action = "<CMD>lua require'telescope.builtin'.lsp_document_symbols{}<Cr>";
    }
    {
      # Helix-like `Space d`: show document diagnostics through Telescope.
      mode = "n";
      key = "<Space>d";
      action = "<CMD>lua require'telescope.builtin'.diagnostics{bufnr=0}<Cr>";
    }
    {
      # Helix-like `Space D`: show workspace diagnostics through Telescope.
      mode = "n";
      key = "<Space>D";
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
      action = "<Cmd>lua vim.lsp.buf.hover()<CR>";
    }
    {
      # Helix-like `Space r`: rename the symbol under the cursor.
      mode = "n";
      key = "<Space>r";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
    }
    {
      # Helix-like `g d`: jump to the symbol definition.
      mode = "n";
      key = "gd";
      action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
    }
    {
      # Helix-like `g y`: jump to the type definition.
      mode = "n";
      key = "gy";
      action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
    }
    {
      # Helix-like `g r`: show references through Telescope.
      mode = "n";
      key = "gr";
      action = "<CMD>lua require'telescope.builtin'.lsp_references{}<Cr>";
    }
    {
      # Helix-like `g i`: show implementations through Telescope.
      mode = "n";
      key = "gi";
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
      action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
    }
    {
      # Helix-like `g j`: jump to any single-character target with Hop.
      mode = "v";
      key = "gj";
      action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
    }
    {
      # Helix-like `g f`: jump to a single-character target on the current line with Hop.
      mode = "n";
      key = "gf";
      action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
    }
    {
      # Helix-like `g f`: jump to a single-character target on the current line with Hop.
      mode = "v";
      key = "gf";
      action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
    }
  ];
}
