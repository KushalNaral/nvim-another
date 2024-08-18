return {
	"phaazon/hop.nvim",
	branch = "v2", -- optional but strongly recommended
	config = function()
		require("hop").setup({
			keys = "etovxqpdygfblzhckisuran",
			case_insensitive = false,
			uppercase_labels = true,
		})
	end,
}
