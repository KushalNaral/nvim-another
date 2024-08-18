local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("keymaps")
require("lazy").setup({
	spec = {
		{ import = "plugins" }, -- loads all plugins in plugins/
	},
	defaults = {
		lazy = false, -- plugins are not lazy loaded by default
	},
})

local hop = require("hop")
local directions = require("hop.hint").HintDirection
vim.keymap.set("", "f", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR })
end, { remap = true })
vim.keymap.set("", "F", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR })
end, { remap = true })
vim.keymap.set("", "t", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, hint_offset = -1 })
end, { remap = true })
vim.keymap.set("", "T", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, hint_offset = 1 })
end, { remap = true })
