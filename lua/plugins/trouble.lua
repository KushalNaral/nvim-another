return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	opts = {
		-- Auto behaviors for enhanced UX
		auto_close = true, -- Auto close when no items
		auto_open = false, -- Manual control over opening
		auto_preview = true, -- Auto preview on cursor move
		auto_refresh = true, -- Keep data fresh
		auto_jump = false, -- Don't auto-jump with single item

		-- Window focus and behavior
		focus = true, -- Focus trouble window when opened
		restore = true, -- Restore last position
		follow = true, -- Follow current item

		-- Visual enhancements
		indent_guides = true, -- Beautiful indent guides
		max_items = 500, -- Increased capacity
		multiline = true, -- Show full messages
		pinned = false, -- Default unpinned for flexibility
		warn_no_results = true,
		open_no_results = false,

		-- Enhanced window configuration
		win = {
			type = "split", -- Default to split
			position = "bottom",
			size = 15, -- Reasonable height
			border = "rounded", -- Prettier borders
			title = true,
			title_pos = "center",
			padding = { 1, 2 }, -- Better spacing
			zindex = 200, -- Above most windows
			-- Enhanced styling
			wo = {
				winblend = 5, -- Slight transparency
				winhighlight = "Normal:TroubleNormal,FloatBorder:TroubleBorder",
			},
		},

		-- Intelligent preview configuration
		preview = {
			type = "float", -- Floating preview for better UX
			border = "rounded",
			title = "Preview",
			title_pos = "center",
			position = { 0.5, 0.4 }, -- Centered positioning
			size = { width = 0.6, height = 0.6 },
			scratch = false, -- Always use real buffers
			wo = {
				winblend = 10,
				winhighlight = "Normal:TroublePreview,FloatBorder:TroublePreviewBorder",
			},
		},

		-- Optimized throttling for smooth performance
		throttle = {
			refresh = 20,
			update = 10,
			render = 10,
			follow = 50, -- Faster following
			preview = { ms = 50, debounce = true }, -- Snappier preview
		},

		-- Comprehensive key mappings
		keys = {
			-- Help and information
			["?"] = "help",
			["<F1>"] = "help",

			-- Basic navigation and actions
			["q"] = "close",
			["<esc>"] = "cancel",
			["<cr>"] = "jump",
			["<2-leftmouse>"] = "jump",
			["o"] = "jump_close",
			["O"] = "jump_only",

			-- Enhanced navigation
			["j"] = "next",
			["k"] = "prev",
			["}"] = "next",
			["{"] = "prev",
			["]]"] = "next",
			["[["] = "prev",
			["gg"] = "first",
			["G"] = "last",
			["<C-d>"] = { action = "next", count = 10 },
			["<C-u>"] = { action = "prev", count = 10 },

			-- Window splitting options
			["<c-s>"] = "jump_split",
			["<c-v>"] = "jump_vsplit",
			["<c-t>"] = {
				action = function(view)
					local item = view:at()
					if item then
						vim.cmd("tabnew")
						view:jump({ item = item })
					end
				end,
				desc = "Jump to item in new tab",
			},

			-- Split and close combinations
			["<leader><tab>s"] = "jump_split_close",
			["<leader><tab>v"] = "jump_vsplit_close",

			-- Item management
			["dd"] = "delete",
			["d"] = { action = "delete", mode = "v" },
			["x"] = "delete",

			-- Preview controls
			["p"] = "preview",
			["P"] = "toggle_preview",
			["<space>"] = "preview",

			-- Refresh controls
			["r"] = "refresh",
			["R"] = "toggle_refresh",
			["<F5>"] = "refresh",

			-- Folding controls (comprehensive)
			["zo"] = "fold_open",
			["zO"] = "fold_open_recursive",
			["zc"] = "fold_close",
			["zC"] = "fold_close_recursive",
			["za"] = "fold_toggle",
			["zA"] = "fold_toggle_recursive",
			["zm"] = "fold_more",
			["zM"] = "fold_close_all",
			["zr"] = "fold_reduce",
			["zR"] = "fold_open_all",
			["zx"] = "fold_update",
			["zX"] = "fold_update_all",
			["zn"] = "fold_disable",
			["zN"] = "fold_enable",
			["zi"] = "fold_toggle_enable",

			-- Custom intelligent filters
			["gb"] = {
				action = function(view)
					view:filter({ buf = 0 }, { toggle = true })
				end,
				desc = "Toggle Current Buffer Filter",
			},

			["gs"] = {
				action = function(view)
					local f = view:get_filter("severity")
					local severity = ((f and f.filter.severity or 0) + 1) % 5
					view:filter({ severity = severity }, {
						id = "severity",
						template = "{hl:Title}Severity Filter:{hl} {severity}",
						del = severity == 0,
					})
				end,
				desc = "Cycle Severity Filter",
			},

			["gf"] = {
				action = function(view)
					local current_file = vim.fn.expand("%:p")
					view:filter({ filename = current_file }, { toggle = true })
				end,
				desc = "Toggle Current File Filter",
			},

			["gt"] = {
				action = function(view)
					-- Toggle between error types
					local filters = { "Error", "Warning", "Info", "Hint" }
					local current_filter = view:get_filter("diagnostic_type")
					local current_type = current_filter and current_filter.filter.diagnostic_type
					local next_index = 1

					if current_type then
						for i, filter_type in ipairs(filters) do
							if filter_type == current_type then
								next_index = (i % #filters) + 1
								break
							end
						end
					end

					view:filter({ diagnostic_type = filters[next_index] }, {
						id = "diagnostic_type",
						template = "{hl:Title}Type:{hl} {diagnostic_type}",
					})
				end,
				desc = "Cycle Diagnostic Type Filter",
			},

			-- Clear all filters
			["gc"] = {
				action = function(view)
					view:filter({}, { clear = true })
				end,
				desc = "Clear All Filters",
			},

			-- Inspection and debugging
			["i"] = "inspect",
			["<leader><tab>i"] = {
				action = function(view)
					local item = view:at()
					if item then
						print(vim.inspect(item))
					end
				end,
				desc = "Inspect Current Item (detailed)",
			},

			-- Quick actions for different modes
			["<leader><tab>d"] = {
				action = function()
					require("trouble").open("diagnostics")
				end,
				desc = "Open Diagnostics",
			},

			["<leader><tab>r"] = {
				action = function()
					require("trouble").open("lsp_references")
				end,
				desc = "Open References",
			},

			["<leader><tab>D"] = {
				action = function()
					require("trouble").open("lsp_definitions")
				end,
				desc = "Open Definitions",
			},
		},

		-- Enhanced modes configuration
		modes = {
			-- Diagnostics with custom configuration
			diagnostics = {
				auto_open = false,
				auto_close = true,
				focus = true,
				win = { position = "bottom", size = 12 },
				filter = {
					any = {
						buf = 0, -- Current buffer
						severity = vim.diagnostic.severity.ERROR,
					},
				},
			},

			-- Buffer-specific diagnostics
			buffer_diagnostics = {
				mode = "diagnostics",
				filter = { buf = 0 },
				desc = "Buffer Diagnostics",
				win = { position = "bottom", size = 10 },
			},

			-- Project-wide diagnostics with severity filtering
			project_diagnostics = {
				mode = "diagnostics",
				desc = "Project Diagnostics",
				filter = {
					severity = { min = vim.diagnostic.severity.WARN },
				},
				win = { position = "bottom", size = 15 },
			},

			-- Enhanced LSP references
			lsp_references = {
				desc = "LSP References",
				params = {
					include_declaration = true,
					include_current = false,
				},
				win = { position = "right", size = 50 },
				filter = { buf = 0 },
			},

			-- Enhanced symbols with better filtering
			symbols = {
				desc = "Document Symbols",
				mode = "lsp_document_symbols",
				focus = false,
				win = {
					position = "right",
					size = 40,
					border = "rounded",
				},
				filter = {
					["not"] = { ft = "lua", kind = "Package" },
					any = {
						ft = { "help", "markdown" },
						kind = {
							"Class",
							"Constructor",
							"Enum",
							"Field",
							"Function",
							"Interface",
							"Method",
							"Module",
							"Namespace",
							"Package",
							"Property",
							"Struct",
							"Trait",
							"Variable",
							"Constant",
						},
					},
				},
			},

			-- Custom modes for specific workflows
			errors_only = {
				mode = "diagnostics",
				desc = "Errors Only",
				filter = { severity = vim.diagnostic.severity.ERROR },
				win = { position = "bottom", size = 8 },
			},

			warnings_only = {
				mode = "diagnostics",
				desc = "Warnings Only",
				filter = { severity = vim.diagnostic.severity.WARN },
				win = { position = "bottom", size = 8 },
			},

			-- Telescope integration mode
			telescope_results = {
				mode = "telescope",
				desc = "Telescope Results",
				win = { position = "bottom", size = 12 },
			},

			-- LSP definitions with preview
			lsp_definitions = {
				desc = "LSP Definitions",
				auto_preview = true,
				win = { position = "right", size = 45 },
				preview = {
					type = "split",
					position = "right",
					size = 0.6,
				},
			},

			-- Incoming calls view
			incoming_calls = {
				mode = "lsp_incoming_calls",
				desc = "Incoming Calls",
				win = { position = "bottom", size = 12 },
			},

			-- Outgoing calls view
			outgoing_calls = {
				mode = "lsp_outgoing_calls",
				desc = "Outgoing Calls",
				win = { position = "bottom", size = 12 },
			},
		},

		-- Enhanced icons with better visual hierarchy
		icons = {
			indent = {
				top = "│ ",
				middle = "├╴",
				last = "└╴",
				fold_open = " ",
				fold_closed = " ",
				ws = "  ",
			},
			folder_closed = " ",
			folder_open = " ",
			-- Comprehensive kind icons
			kinds = {
				Array = " ",
				Boolean = "󰨙 ",
				Class = " ",
				Constant = "󰏿 ",
				Constructor = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Function = "󰊕 ",
				Interface = " ",
				Key = " ",
				Method = "󰊕 ",
				Module = " ",
				Namespace = "󰦮 ",
				Null = " ",
				Number = "󰎠 ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				String = " ",
				Struct = "󰆼 ",
				TypeParameter = " ",
				Variable = "󰀫 ",
			},
		},
	},

	-- Comprehensive key mappings for different contexts
	keys = {
		-- Core trouble operations
		{
			"<leader><tab>tt",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "󰔫 Toggle Diagnostics",
		},
		{
			"<leader><tab>tT",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "󰔫 Toggle Buffer Diagnostics",
		},
		{
			"<leader><tab>ts",
			"<cmd>Trouble symbols toggle focus=false win.position=right<cr>",
			desc = "󰆼 Toggle Symbols Outline",
		},
		{
			"<leader><tab>tl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "󰒕 Toggle LSP References",
		},
		{
			"<leader><tab>tL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "󰍉 Toggle Location List",
		},
		{
			"<leader><tab>tq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "󰍉 Toggle Quickfix List",
		},

		-- Specialized diagnostic views
		{
			"<leader><tab>te",
			"<cmd>Trouble errors_only toggle<cr>",
			desc = "󰅚 Show Errors Only",
		},
		{
			"<leader><tab>tw",
			"<cmd>Trouble warnings_only toggle<cr>",
			desc = "󰀨 Show Warnings Only",
		},
		{
			"<leader><tab>tb",
			"<cmd>Trouble buffer_diagnostics toggle<cr>",
			desc = "󰓫 Buffer Diagnostics",
		},
		{
			"<leader><tab>tp",
			"<cmd>Trouble project_diagnostics toggle<cr>",
			desc = "󰔫 Project Diagnostics",
		},

		-- LSP specific views
		{
			"<leader><tab>tr",
			"<cmd>Trouble lsp_references toggle<cr>",
			desc = "󰈇 LSP References",
		},
		{
			"<leader><tab>td",
			"<cmd>Trouble lsp_definitions toggle<cr>",
			desc = "󰳽 LSP Definitions",
		},
		{
			"<leader><tab>ti",
			"<cmd>Trouble lsp_implementations toggle<cr>",
			desc = "󰡱 LSP Implementations",
		},
		{
			"<leader><tab>tD",
			"<cmd>Trouble lsp_type_definitions toggle<cr>",
			desc = "󰊄 Type Definitions",
		},
		{
			"<leader><tab>tc",
			"<cmd>Trouble incoming_calls toggle<cr>",
			desc = "󰏷 Incoming Calls",
		},
		{
			"<leader><tab>tC",
			"<cmd>Trouble outgoing_calls toggle<cr>",
			desc = "󰏻 Outgoing Calls",
		},

		-- Navigation shortcuts
		{
			"]t",
			function()
				require("trouble").next({ skip_groups = true, jump = true })
			end,
			desc = "Next Trouble Item",
		},
		{
			"[t",
			function()
				require("trouble").prev({ skip_groups = true, jump = true })
			end,
			desc = "Previous Trouble Item",
		},
		{
			"]T",
			function()
				require("trouble").first({ skip_groups = true, jump = true })
			end,
			desc = "First Trouble Item",
		},
		{
			"[T",
			function()
				require("trouble").last({ skip_groups = true, jump = true })
			end,
			desc = "Last Trouble Item",
		},

		-- Quick access to specific modes
		{
			"<leader><tab><leader><tab>t",
			function()
				-- Smart toggle based on current buffer diagnostics
				local diagnostics = vim.diagnostic.get(0)
				if #diagnostics > 0 then
					require("trouble").toggle("buffer_diagnostics")
				else
					require("trouble").toggle("project_diagnostics")
				end
			end,
			desc = "󰔫 Smart Diagnostics Toggle",
		},

		-- Integration with other tools
		{
			"<leader><tab>tF",
			function()
				require("trouble").open("telescope_results")
			end,
			desc = "󰔭 Open Telescope Results",
			silent = true,
		},
	},

	-- Setup function for additional configuration
	config = function(_, opts)
		require("trouble").setup(opts)

		-- Auto-commands for enhanced UX
		vim.api.nvim_create_autocmd("BufReadPost", {
			group = vim.api.nvim_create_augroup("TroubleAutoOpen", { clear = true }),
			callback = function()
				-- Auto-open diagnostics if there are errors in the buffer
				vim.defer_fn(function()
					local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					if #diagnostics > 0 and vim.bo.filetype ~= "trouble" then
						-- Optional: Auto-open trouble for files with errors
						-- require("trouble").open("buffer_diagnostics")
					end
				end, 1000)
			end,
		})

		-- Enhanced statusline integration
		vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("TroubleStatusline", { clear = true }),
			callback = function()
				-- Update statusline when diagnostics change
				vim.cmd("redrawstatus")
			end,
		})

		-- Custom highlight groups for better visual distinction
		vim.api.nvim_set_hl(0, "TroubleBorder", { link = "FloatBorder" })
		vim.api.nvim_set_hl(0, "TroublePreviewBorder", { link = "FloatBorder" })

		-- Set up custom commands for power users
		vim.api.nvim_create_user_command("TroubleWorkspace", function()
			require("trouble").open("project_diagnostics")
		end, { desc = "Open workspace diagnostics" })

		vim.api.nvim_create_user_command("TroubleBuffer", function()
			require("trouble").open("buffer_diagnostics")
		end, { desc = "Open buffer diagnostics" })

		vim.api.nvim_create_user_command("TroubleErrors", function()
			require("trouble").open("errors_only")
		end, { desc = "Show errors only" })

		vim.api.nvim_create_user_command("TroubleWarnings", function()
			require("trouble").open("warnings_only")
		end, { desc = "Show warnings only" })
	end,
}
