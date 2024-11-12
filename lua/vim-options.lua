-- local opt = vim.opt -- for conciseness
--
-- -- Numeracion de las lineas
-- opt.relativenumber = true
-- opt.number = true
-- opt.showtabline = 2
-- -- tabs & indentation
-- opt.tabstop = 4
-- opt.shiftwidth = 4
-- opt.softtabstop = 4
-- opt.expandtab = true
-- opt.autoindent = true
--
-- -- Line wrapping
-- opt.wrap = true
--
-- -- Search setting
-- opt.ignorecase = true
-- opt.smartcase = true
--
-- -- Cursor line
-- opt.cursorline = true
--
-- -- appearance
-- opt.termguicolors = true
-- opt.background = "dark"
-- opt.signcolumn = "yes"
--
-- -- Backspace
-- opt.backspace = "indent,eol,start"
--
-- -- Clipboard
-- opt.clipboard:append("unnamedplus")
--
-- -- Splitt Windows
-- opt.splitright = true
-- opt.splitbelow = true
--
-- opt.iskeyword:append("-")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
-- vim.opt.ambiwidth= 'double'

vim.opt.cursorline = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.getenv("HOME") .. "/.vimdid"
vim.opt.undofile = true
vim.opt.scrolloff = 999
vim.opt.laststatus = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.relativenumber = true
vim.opt.number = true

vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldlevel = 1000
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

if vim.fn.has("macunix") then
	vim.opt.clipboard:append({ "unnamedplus" })
end

-- au TextYankPost * silent! lua vim.highlight.on_yank()
vim.cmd("au TextYankPost * silent! lua.highlight.on_yank()")

-- no line numbers when using the teminal
vim.cmd("au TermOpen * setlocal nonumber norelativenumber")

-- format on save
vim.cmd("au BufWritePre * lua vim.lsp.buf.format()")

vim.opt.background = "dark" -- set this to dark or light

-- for folding features
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

