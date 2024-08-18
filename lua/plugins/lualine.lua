return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			options = {
				theme = "oxocarbon",
			},
			sections = {
				lualine_c = { { "filename", file_status = true, path = 1 } },
			},
		})
	end,
}
