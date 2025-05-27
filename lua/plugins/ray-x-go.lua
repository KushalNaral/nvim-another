return {
	-- Go plugin for LSP, formatting, debugging, and more
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua", -- For floating windows and enhanced UI
			"neovim/nvim-lspconfig", -- LSP configuration
			"nvim-treesitter/nvim-treesitter", -- Treesitter for syntax highlighting and textobjects
			"williamboman/mason.nvim", -- Manage external tools
			"williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
			"mfussenegger/nvim-dap", -- DAP for debugging
			"rcarriga/nvim-dap-ui", -- DAP UI for better debugging experience
			"theHamsta/nvim-dap-virtual-text", -- Virtual text for debugging
			"nvim-neotest/nvim-nio", -- Required for DAP UI
			"L3MON4D3/LuaSnip", -- For snippet support
		},
		config = function()
			-- Setup go.nvim with comprehensive configuration
			require("go").setup({
				-- General settings
				go = "go", -- Specify go command
				goimports = "goimports", -- Use goimports for formatting
				gofmt = "gofumpt", -- Use gofumpt for stricter formatting
				max_line_len = 120, -- Set max line length for golines
				comment_placeholder = "📝 ", -- Custom placeholder for comments
				icons = { breakpoint = "🛑", currentpos = "➡️" }, -- Custom DAP icons
				verbose = false, -- Disable verbose logging
				run_in_floaterm = true, -- Run tests in floating terminal

				-- LSP configuration
				lsp_cfg = true, -- Use go.nvim's default gopls setup
				lsp_gofumpt = true, -- Enable gofumpt in gopls
				lsp_keymaps = false, -- Disable default LSP keymaps to avoid conflicts
				lsp_codelens = true, -- Enable gopls codelens
				lsp_document_formatting = true, -- Use gopls for formatting
				lsp_inlay_hints = { enable = true }, -- Enable inlay hints
				gopls_remote_auto = true, -- Auto-configure gopls remote

				-- DAP configuration
				dap_debug = true, -- Enable DAP debugging
				dap_debug_keymap = false, -- Disable default DAP keymaps to set custom ones
				dap_debug_gui = {
					icons = { expanded = "▾", collapsed = "▸" },
					mappings = {
						expand = { "<CR>", "<2-LeftMouse>" },
						open = "o",
						remove = "d",
						edit = "e",
						repl = "r",
						toggle = "t",
					},
					layouts = {
						{
							elements = {
								{ id = "scopes", size = 0.25 },
								{ id = "breakpoints", size = 0.25 },
								{ id = "stacks", size = 0.25 },
								{ id = "watches", size = 0.25 },
							},
							size = 40,
							position = "left",
						},
						{
							elements = { "repl", "console" },
							size = 0.25,
							position = "bottom",
						},
					},
					floating = {
						max_height = 0.9,
						max_width = 0.9,
						border = "rounded",
						mappings = { close = { "q", "<Esc>" } },
					},
				},
				dap_debug_vt = {
					enabled = true,
					enabled_commands = true,
					all_frames = true,
					virt_text_pos = "inline",
				},
				dap_port = 38697, -- Default Delve port
				dap_timeout = 15, -- Timeout for DAP initialization
				dap_retries = 20, -- Retry attempts for DAP

				-- Testing configuration
				test_runner = "gotestsum", -- Use gotestsum for enhanced test output
				verbose_tests = true, -- Enable verbose test output
				gotest_case_exact_match = true, -- Exact match for test case names

				-- Formatting on save
				lsp_on_attach = function(client, bufnr)
					local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = "*.go",
						callback = function()
							require("go.format").goimports()
						end,
						group = format_sync_grp,
					})
				end,

				-- Floaterm configuration
				floaterm = {
					position = "center",
					width = 0.8,
					height = 0.8,
					title_colors = "nord",
				},

				-- Snippet support
				luasnip = true, -- Enable go.nvim's luasnip snippets

				-- CodeLens
				lsp_codelens = function(bufnr)
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>al",
						"<cmd>lua vim.lsp.codelens.run()<CR>",
						{ noremap = true, silent = true }
					)
				end,

				-- Diagnostic settings
				diagnostic = {
					hdlr = true,
					underline = true,
					virtual_text = { spacing = 2, prefix = "🔍" },
					signs = { "🔴", "🟡", "🔵", "⚪" },
					update_in_insert = false,
				},

				-- Golangci-lint integration
				golangci_lint = {
					default = "standard",
					severity = vim.diagnostic.severity.INFO,
				},

				-- Build tags
				build_tags = "integration",
			})

			-- DAP adapter for Go (Delve)
			local dap = require("dap")
			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
					detached = true,
				},
			}

			-- DAP configurations
			dap.configurations.go = {
				{
					type = "go",
					name = "Launch file",
					request = "launch",
					program = "${file}",
					args = function()
						return vim.split(vim.fn.input("Args: "), " ")
					end,
				},
				{
					type = "go",
					name = "Launch package",
					request = "launch",
					program = "${fileDirname}",
				},
				{
					type = "go",
					name = "Launch test",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					type = "go",
					name = "Attach remote",
					request = "attach",
					mode = "remote",
					port = 38697,
				},
			}

			-- DAP UI setup
			require("dapui").setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "➡️" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = { "repl", "console" },
						size = 0.25,
						position = "bottom",
					},
				},
				floating = {
					max_height = 0.9,
					max_width = 0.9,
					border = "rounded",
					mappings = { close = { "q", "<Esc>" } },
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "↘",
						step_over = "↗",
						step_out = "↖",
						step_back = "↙",
						run_last = "⟳",
						terminate = "■",
					},
				},
			})

			-- Virtual text for debugging
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				highlight_changed_variables = true,
				virt_text_pos = "inline",
				show_stop_reason = true,
				commented = true,
			})

			-- Mason setup
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls", "delve" },
			})

			-- Custom keybindings
			local keymap = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }

			-- DAP keybindings (prefix: <leader>d)
			keymap("n", "<leader>dc", "<Cmd>lua require'dap'.continue()<CR>", opts) -- Continue
			keymap("n", "<leader>dn", "<Cmd>lua require'dap'.step_over()<CR>", opts) -- Next (step over)
			keymap("n", "<leader>di", "<Cmd>lua require'dap'.step_into()<CR>", opts) -- Step into
			keymap("n", "<leader>do", "<Cmd>lua require'dap'.step_out()<CR>", opts) -- Step out
			keymap("n", "<leader>db", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts) -- Toggle breakpoint
			keymap("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts) -- Open REPL
			keymap("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts) -- Run last
			keymap("n", "<leader>dt", "<Cmd>lua require'dapui'.toggle()<CR>", opts) -- Toggle DAP UI
			keymap("n", "<leader>ds", "<Cmd>GoDebug -s<CR>", opts) -- Stop debugging
			keymap("n", "<leader>dk", "<Cmd>GoDbgKeys<CR>", opts) -- Show debug keybindings

			-- go.nvim keybindings (prefix: <leader>a)
			keymap("n", "<leader>zf", "<Cmd>GoFmt<CR>", opts) -- Format code
			keymap("n", "<leader>zt", "<Cmd>GoTest<CR>", opts) -- Run tests
			keymap("n", "<leader>zc", "<Cmd>lua require('go.comment').gen()<CR>", opts) -- Generate comments
			keymap("n", "<leader>za", "<Cmd>GoAddTag<CR>", opts) -- Add struct tags
			keymap("n", "<leader>zr", "<Cmd>GoRmTag<CR>", opts) -- Remove struct tags
			keymap("n", "<leader>zi", "<Cmd>GoImpl<CR>", opts) -- Generate interface implementation
			keymap("n", "<leader>zm", "<Cmd>GoMockGen<CR>", opts) -- Generate mocks
			keymap("n", "<leader>zd", "<Cmd>GoDoc<CR>", opts) -- Show documentation
			keymap("n", "<leader>zo", "<Cmd>GoPkgOutline<CR>", opts) -- Package outline
			keymap("n", "<leader>zs", "<Cmd>GoAlt<Cmd>", opts) -- Switch to/from test file
			keymap("n", "<leader>zl", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts) -- Run codelens

			keymap("n", "<leader>zgr", "<Cmd>GoRun<CR>", opts) -- Run file
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
		build = ':lua require("go.install").update_all_sync()',
	},
}
