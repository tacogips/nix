{ ... }:
{
  settings.vim = {
    augroups = [
      {
        name = "TrimWhitespace";
        clear = true;
      }
      {
        name = "FormatAutogroup";
        clear = true;
      }
    ];

    autocmds = [
      {
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
        group = "TrimWhitespace";
        command = "%s/\\s\\+$//ge";
      }
      {
        event = [ "BufWritePost" ];
        pattern = [ "*" ];
        group = "FormatAutogroup";
        command = "FormatWrite";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "*.{md,mdwn,mkd,mkdn,mark*}" ];
        command = "set filetype=markdown";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "*.dig" ];
        command = "set filetype=yaml";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "*.vtl" ];
        command = "set ft=velocity";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "nginx.conf" ];
        command = "set ft=nginx";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "Dockerfile*" ];
        command = "set filetype=dockerfile";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "*.png" ];
        command = "setlocal filetype=png";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [
          "*.jpg"
          "*.jpeg"
        ];
        command = "setlocal filetype=jpeg";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [ "*.zon" ];
        command = "set filetype=zig";
      }
      {
        event = [ "Syntax" ];
        pattern = [ "yaml" ];
        command = "setlocal indentkeys-=<:> indentkeys-=0#";
      }
      {
        event = [ "FileType" ];
        pattern = [ "go" ];
        command = "nmap <buffer> .r <ESC>:GoRun<CR> | nmap <buffer> .b <ESC>:GoBuild<CR> | nmap <buffer> .t <ESC>:GoTest<CR> | nmap <buffer> .l <ESC>:GoLint<CR> | nmap <buffer> .v <ESC>:GoVet<CR>";
      }
      {
        event = [ "FileType" ];
        pattern = [ "go" ];
        command = "match goErr /\\<err\\>/ | highlight goErr cterm=bold ctermfg=214";
      }
      {
        event = [ "FileType" ];
        pattern = [ "plantuml" ];
        command = "nmap <buffer> .r <ESC>:make<CR>";
      }
      {
        event = [ "FileType" ];
        pattern = [ "python" ];
        command = "noremap <buffer> .t <ESC>:TestFile<CR>";
      }
      {
        event = [ "FileType" ];
        pattern = [ "rust" ];
        command = "nmap <buffer> .f <ESC>:Cargo fix<CR> | nmap <buffer> .r <ESC>:Cargo run<CR> | nmap <buffer> .b <ESC>:Cargo check<CR> | nmap <buffer> .l <ESC>:Cargo clippy<CR> | nmap <buffer> .t <ESC>:Cargo nextest run<CR>";
      }
      {
        event = [ "FileType" ];
        pattern = [ "typescript" ];
        command = "inoremap <buffer> <C-Space> <C-x><C-o>";
      }
    ];
  };
}
