local cmd = vim.cmd
local util = require("formatter.util")
local defaults = require("formatter.defaults")
require("formatter").setup({
	logging = false,
	log_level = vim.log.levels.WARN,
	filetype = {
		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		typescriptreact = {
			require("formatter.filetypes.typescriptreact").prettier,
		},

		vue = {
			util.copyf(defaults.prettier),
		},

		svelte = {
			util.copyf(defaults.prettier),
		},

		proto = {
			function()
				return {
					exe = "buf",
					args = { "format" },
					stdin = true,
				}
			end,
		},

		graphql = {
			require("formatter.filetypes.graphql").prettier,
		},

		html = {
			require("formatter.filetypes.html").prettier,
		},

		c = {
			require("formatter.filetypes.c").clangformat,
		},
		solidity = {
			function()
				return {
					exe = "forge",
					args = { "fmt", "--raw", "-" },
					stdin = true,
				}
			end,
		},

		css = {
			require("formatter.filetypes.css").prettier,
		},

		yaml = {
			require("formatter.filetypes.yaml").prettier,
		},
		sql = {
			function()
				return {
					exe = "sqlfmt",
					args = { "-" },
					stdin = true,
				}
			end,
		},

		terraform = {
			function()
				return {
					exe = "terraform",
					args = { "fmt", "-" },
					stdin = true,
				}
			end,
		},

		-- it expands imported justfiles
		--just = {
		--	function()
		--		return {
		--			exe = "just",
		--			args = { "--fmt", "--unstable", "-" },
		--			stdin = true,
		--		}
		--	end,
		--},

		python = {
			function()
				return {
					exe = "black",
					args = { "-q", "-" },
					stdin = true,
				}
			end,
		},
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = { "--edition", "2021" },
					stdin = true,
				}
			end,
		},
		go = {
			require("formatter.filetypes.go").goimports,
		},

		json = require("formatter.filetypes.json").prettier,

		zig = {
			function()
				return {
					exe = "zig",
					args = { "fmt", "--stdin" },
					stdin = true,
				}
			end,
		},

		toml = {
			function()
				if util.get_current_buffer_file_name() == "Cargo.lock" then
					return nil
				end
				return {
					exe = "taplo",
					args = { "fmt", "-" },

					stdin = true,
					try_node_modules = true,
				}
			end,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},

		fennel = {
			function()
				return {
					exe = "fnlfmt",
					args = { "-" },
					stdin = true,
				}
			end,
		},

		nix = {
			function()
				return {
					--exe = "alejandra",
					-- nixpkgs-fmt seems compatible with nixpkgs
					--exe = "nixpkgs-fmt",
					exe = "nixfmt",
					args = {},
					stdin = true,
				}
			end,
		},

		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
cmd([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]])
