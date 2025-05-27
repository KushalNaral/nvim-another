return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "moon", -- Matches Kitty's dark theme
				dark_variant = "main",
				bold_vert_split = false,
				dim_nc_background = false,
				disable_background = false,
				disable_float_background = false,
				disable_italics = false,
				highlight_groups = {
					Comment = { italic = true },
					VertSplit = { fg = "#6e6a86" },
				},
			})
		end,
	},
}
