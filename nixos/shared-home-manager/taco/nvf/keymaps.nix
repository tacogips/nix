{ ... }:
{
  settings.vim.keymaps = [
    {
      mode = "c";
      key = "<C-g>";
      action = "<C-c>";
    }
    {
      mode = "c";
      key = "<C-a>";
      action = "<C-b>";
    }
    {
      mode = "i";
      key = "<C-d>";
      action = "<Delete>";
    }
    {
      mode = "i";
      key = "<C-h>";
      action = "<Bs>";
    }
    {
      mode = "i";
      key = "<C-f>";
      action = "<Right>";
    }
    {
      mode = "i";
      key = "<C-b>";
      action = "<Left>";
    }
    {
      mode = "i";
      key = "kj";
      action = "<ESC><ESC>";
    }
    {
      mode = "i";
      key = "<C-v>";
      action = "<C-R>+";
    }
    {
      mode = "i";
      key = "<ESC>";
      action = "<ESC>:set iminsert=0<CR>";
    }
    {
      mode = "i";
      key = "<C-j>";
      action = "<nop>";
    }
    {
      mode = "i";
      key = "<C-a>";
      action = "<Cmd>lua vimrc.cmp.lsp()<CR>";
    }
    {
      mode = "n";
      key = "Q";
      action = "<Nop>";
    }
    {
      mode = "n";
      key = "gQ";
      action = "<Nop>";
    }
    {
      mode = "n";
      key = "<Esc><Esc>";
      action = ":set nohlsearch<CR>";
    }
    {
      mode = "n";
      key = "j";
      action = "gj";
    }
    {
      mode = "n";
      key = "k";
      action = "gk";
    }
    {
      mode = "n";
      key = "+";
      action = "g;";
    }
    {
      mode = "n";
      key = "J";
      action = "gJ";
    }
    {
      mode = "n";
      key = "bp";
      action = ":bprevious<CR>";
    }
    {
      mode = "n";
      key = "bn";
      action = ":bnext<CR>";
    }
    {
      mode = "n";
      key = "<Space>.";
      action = ":<C-u>so $MYVIMRC<CR>";
    }
    {
      mode = "n";
      key = ".vr";
      action = ":%y\\|@\"<CR>";
    }
    {
      mode = "n";
      key = ",w";
      action = ":write<CR>";
    }
    {
      mode = "n";
      key = "<Space>w";
      action = ":write<CR>";
    }
    {
      mode = "n";
      key = ".y";
      action = ":let @+=getcwd()<CR>";
    }
    {
      mode = "n";
      key = "<Space><Space>";
      action = "i <Esc><Right>";
    }
    {
      mode = "n";
      key = "<Space>j";
      action = "i<CR><ESC>";
    }
    {
      mode = "n";
      key = "<Space>x";
      action = "xi<Space><ESC>";
    }
    {
      mode = "n";
      key = "<Space>n";
      action = ":bn!<CR>";
    }
    {
      mode = "n";
      key = "<Space>b";
      action = ":bp!<CR>";
    }
    {
      mode = "n";
      key = "<Space>o";
      action = ":on!<CR>";
    }
    {
      mode = "n";
      key = "<Space>q";
      action = ":q!<CR>";
    }
    {
      mode = "n";
      key = "<Space>1";
      action = ":qa!<CR>";
    }
    {
      mode = "n";
      key = "<Space>r";
      action = ":QuickRun<CR>";
    }
    {
      mode = "n";
      key = "<Space>t";
      action = "<cmd>AerialToggle!<CR>";
    }
    {
      mode = "n";
      key = ",e";
      action = ":e! %<CR>";
    }
    {
      mode = "n";
      key = ",y";
      action = ":tabo<CR>";
    }
    {
      mode = "n";
      key = ",.";
      action = "<CMD>lua require'telescope.builtin'.git_status{}<Cr>";
    }
    {
      mode = "n";
      key = ",c";
      action = "<CMD>lua require'telescope.builtin'.git_commits{}<Cr>";
    }
    {
      mode = "n";
      key = ",,";
      action = "<CMD>:Telescope oldfiles<Cr>";
    }
    {
      mode = "n";
      key = ",b";
      action = "<CMD>lua require'telescope.builtin'.buffers{}<CR>";
    }
    {
      mode = "n";
      key = ",f";
      action = "<CMD>lua require'telescope.builtin'.git_files{}<Cr>";
    }
    {
      mode = "n";
      key = ",g";
      action = "<CMD>lua require'telescope.builtin'.live_grep{}<Cr>";
    }
    {
      mode = "n";
      key = ",l";
      action = "<CMD>lua require'telescope.builtin'.git_branches{}<Cr>";
    }
    {
      mode = "n";
      key = ",m";
      action = "<CMD>lua require'telescope.builtin'.marks{}<Cr>";
    }
    {
      mode = "n";
      key = ",h";
      action = "<CMD>lua require'telescope.builtin'.command_history{}<Cr>";
    }
    {
      mode = "n";
      key = ",k";
      action = "<CMD>lua require'telescope.builtin'.keymaps{}<Cr>";
    }
    {
      mode = "n";
      key = ",z";
      action = "<CMD>lua require'telescope.builtin'.lsp_references{}<Cr>";
    }
    {
      mode = "n";
      key = ",x";
      action = "<CMD>lua require'telescope.builtin'.lsp_implementations{}<Cr>";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      mode = "n";
      key = "<C-e>";
      action = ":vsplit<CR>";
    }
    {
      mode = "n";
      key = "cl";
      action = ":%s/.//gn<CR>";
    }
    {
      mode = "n";
      key = "<C-]>";
      action = "<Cmd>lua vim.lsp.buf.definition()<CR>";
    }
    {
      mode = "n";
      key = "<C-\\>";
      action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
    }
    {
      mode = "n";
      key = "<C-n>";
      action = "<Cmd>lua vim.lsp.buf.hover()<CR>";
    }
    {
      mode = "n";
      key = ".j";
      action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
    }
    {
      mode = "n";
      key = ".e";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
    }
    {
      mode = "n";
      key = "<space>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    }
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    }
    {
      mode = "n";
      key = "<C-g>";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    }
    {
      mode = "n";
      key = ".w";
      action = "<cmd>lua vim.diagnostic.set_loclist()<CR>";
    }
    {
      mode = "n";
      key = ".\\";
      action = ":LspRestart<CR>";
    }
    {
      mode = "v";
      key = "kj";
      action = "<ESC><ESC>";
    }
    {
      mode = "n";
      key = "r";
      action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
    }
    {
      mode = "v";
      key = "r";
      action = "<cmd>lua require'hop'.hint_char1({ })<cr>";
    }
    {
      mode = "n";
      key = "f";
      action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
    }
    {
      mode = "v";
      key = "f";
      action = "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>";
    }
  ];
}
