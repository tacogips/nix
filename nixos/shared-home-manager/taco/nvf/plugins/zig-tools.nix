{
  pkgs,
  mkLuaInline,
  zigToolsPlugin,
  ...
}:
{
  settings.vim.lazy.plugins.zig-tools.nvim = {
    package = zigToolsPlugin;
    setupModule = "zig-tools";
    setupOpts = {
      expose_commands = true;
      formatter = {
        enable = false;
        events = [ ];
      };
      checker = {
        enable = false;
        before_compilation = false;
        events = [ ];
      };
      project = {
        build_tasks = true;
        live_reload = true;
        flags = {
          build = [ "-freference-trace" ];
          run = [ "-freference-trace" ];
        };
        auto_compile = {
          enable = false;
          run = true;
        };
      };
      integrations = {
        package_managers = [
          "zigmod"
          "gyro"
        ];
        zls = {
          hints = false;
          management = {
            enable = false;
            install_path = mkLuaInline ''os.getenv("HOME") .. "/.nix-profile/bin"'';
            source_path = mkLuaInline ''os.getenv("HOME") .. "/.local/zig/zls"'';
          };
        };
      };
      terminal = {
        insert_mappings = false;
        terminal_mappings = false;
        direction = "horizontal";
        auto_scroll = true;
        close_on_exit = false;
      };
    };
  };
}
