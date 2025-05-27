return {
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				contrast = "soft",
				palette_overrides = { light0 = "#fbf1c7" },
			})
		end,
	},
}
