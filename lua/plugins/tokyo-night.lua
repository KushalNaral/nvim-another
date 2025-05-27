return {
	{
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = false,
				styles = { comments = { italic = true } },
			})
		end,
	},
}
