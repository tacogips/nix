{ ... }:
{
  settings.vim.luaConfigRC.telescope = ''
    local telescope_builtin = require("telescope.builtin")

    local function system_lines(cmd, cwd)
      local result = vim.system(cmd, {
        cwd = cwd,
        text = true,
      }):wait()

      return result.code, vim.split(result.stdout or "", "\n", { trimempty = true })
    end

    local function repo_grep_targets()
      local cwd = vim.fn.getcwd()
      local repo_status, repo_lines = system_lines({ "git", "rev-parse", "--show-toplevel" }, cwd)

      if repo_status ~= 0 or #repo_lines == 0 then
        return cwd, nil
      end

      local repo_root = repo_lines[1]
      local files_status, tracked_files = system_lines({ "git", "ls-files" }, repo_root)

      if files_status ~= 0 or #tracked_files == 0 then
        return repo_root, nil
      end

      return repo_root, tracked_files
    end

    local function workspace_type_symbols()
      return {
        "File",
        "Module",
        "Namespace",
        "Package",
        "Class",
        "Field",
        "Constructor",
        "Enum",
        "Interface",
        "String",
        "Number",
        "Boolean",
        "Array",
        "Object",
        "Key",
        "Null",
        "EnumMember",
        "Struct",
        "Event",
        "Operator",
        "TypeParameter",
      }
    end

    _G.taco_workspace_struct_symbols = function()
      telescope_builtin.lsp_workspace_symbols({
        query = "",
        symbols = workspace_type_symbols(),
      })
    end

    _G.taco_workspace_non_struct_symbols = function()
      telescope_builtin.lsp_workspace_symbols({
        query = "",
        ignore_symbols = workspace_type_symbols(),
      })
    end

    _G.taco_workspace_symbols = function()
      telescope_builtin.lsp_workspace_symbols({
        query = "",
      })
    end

    _G.taco_project_live_grep = function()
      local cwd, search_dirs = repo_grep_targets()

      telescope_builtin.live_grep({
        cwd = cwd,
        search_dirs = search_dirs,
      })
    end

    _G.taco_smart_open = function()
      require("telescope").extensions.smart_open.smart_open()
    end

    require("telescope").setup({
      defaults = {
        prompt_prefix = " ❯ ",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom",
        },
        mappings = {
          i = {
            ["<ESC>"] = require("telescope.actions").close,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<TAB>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_next,
            ["<C-s>"] = require("telescope.actions").send_selected_to_qflist,
            ["<C-q>"] = require("telescope.actions").send_to_qflist,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        smart_open = {
          match_algorithm = "fzf",
        },
      },
    })

    pcall(require("telescope").load_extension, "smart_open")
  '';
}
