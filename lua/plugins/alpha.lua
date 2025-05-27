return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- For icons
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Modern, compact banner with a sleek design
		local banner = {
			"                                                    ",
			" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
			" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
			" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
			" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
			" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
			" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			"                                                    ",
			"        🚀 Neovim - Code with Speed & Style        ",
			"                                                    ",
		}

		dashboard.section.header.val = banner

		-- Enhanced button menu with icons and better organization
		dashboard.section.buttons.val = {
			dashboard.button("e", "󰝒  New File", "<cmd>ene <BAR> startinsert<CR>", { desc = "Create a new file" }),
			dashboard.button("SPC f f", "󰈞  Find File", "<cmd>Telescope find_files<CR>", { desc = "Browse files" }),
			dashboard.button(
				"SPC f r",
				"󰋚  Recent Files",
				"<cmd>Telescope oldfiles<CR>",
				{ desc = "Open recent files" }
			),
			dashboard.button(
				"SPC f g",
				"󰍉  Find Text",
				"<cmd>Telescope live_grep<CR>",
				{ desc = "Search in project" }
			),
			dashboard.button(
				"SPC f p",
				"󰄖  Find Project",
				"<cmd>Telescope projects<CR>",
				{ desc = "Switch projects" }
			),
			dashboard.button(
				"SPC s l",
				"󰦒  Last Session",
				"<cmd>SessionRestore<CR>",
				{ desc = "Restore last session" }
			),
			dashboard.button("c", "󰒓  Configuration", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit Neovim config" }),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>", { desc = "Manage plugins" }),
			dashboard.button("m", "󰣖  Mason", "<cmd>Mason<CR>", { desc = "Manage LSP servers" }),
			dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>", { desc = "Exit Neovim" }),
		}

		-- Improved spacing and layout
		dashboard.section.buttons.opts.spacing = 1
		dashboard.section.buttons.opts.width = 50 -- Consistent width for better alignment

		-- Dynamic footer with Lazy.nvim stats and system info
		local function footer()
			local stats = require("lazy").stats()
			local version = vim.version()
			local nvim_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
			local datetime = os.date("  %Y-%m-%d  %H:%M:%S")
			local plugins_loaded = stats.loaded .. "/" .. stats.count .. " plugins"

			return {
				"",
				"⚡ " .. plugins_loaded .. " loaded",
				"🚀 Neovim " .. nvim_version,
				"🕐 " .. datetime,
				"",
				'"Simplicity is the ultimate sophistication." - Leonardo da Vinci',
			}
		end

		dashboard.section.footer.val = footer()

		-- Adaptive highlight groups for light and dark themes
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				local is_dark = vim.o.background == "dark"
				-- Header: Vibrant teal for light, soft cyan for dark
				vim.api.nvim_set_hl(0, "AlphaHeader", { fg = is_dark and "#5eead4" or "#2563eb", bold = true })
				-- Buttons: Neutral tones for readability
				vim.api.nvim_set_hl(0, "AlphaButtons", { fg = is_dark and "#d1d5db" or "#374151" })
				-- Shortcuts: Bright accent color
				vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = is_dark and "#f87171" or "#dc2626", bold = true })
				-- Footer: Subtle and elegant
				vim.api.nvim_set_hl(0, "AlphaFooter", { fg = is_dark and "#9ca3af" or "#6b7280", italic = true })
				-- Icons: Match button color for consistency
				vim.api.nvim_set_hl(0, "AlphaIcons", { fg = is_dark and "#d1d5db" or "#374151" })
			end,
		})

		-- Apply highlight groups
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.buttons.opts.hl_shortcut = "AlphaShortcut"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		-- Apply icons and highlighting to buttons
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
			button.opts.width = 50 -- Uniform width for alignment
		end

		-- Optimized layout with balanced spacing
		dashboard.config.layout = {
			{ type = "padding", val = 3 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 2 },
			dashboard.section.footer,
		}

		-- Additional UX improvements
		dashboard.config.opts.noautocmd = true
		dashboard.config.opts.margin = 5 -- Center content better

		-- Hide statusline and tabline in Alpha
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt_local.laststatus = 0
				vim.opt_local.showtabline = 0
				vim.opt_local.cursorline = false -- Disable cursorline for cleaner look
				vim.opt_local.number = false -- No line numbers
				vim.opt_local.relativenumber = false
			end,
		})

		-- Restore statusline and tabline on leave
		vim.api.nvim_create_autocmd("BufUnload", {
			buffer = 0,
			callback = function()
				vim.opt_local.laststatus = 3
				vim.opt_local.showtabline = 2
				vim.opt_local.cursorline = true
				vim.opt_local.number = true
			end,
		})

		-- Lazy.nvim integration: Auto-update check
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				local lazy = require("lazy")
				if lazy.stats().startuptime > 500 then
					vim.notify(
						"Lazy startup time: " .. lazy.stats().startuptime .. "ms (consider optimizing)",
						vim.log.levels.WARN
					)
				end
			end,
		})

		-- Setup Alpha
		alpha.setup(dashboard.config)
	end,
}
