-- Concise variable for vim options
local opt = vim.opt

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
-- Set scriptencoding using Vimscript command

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4 -- Consistent width for line numbers
opt.signcolumn = "yes:1" -- Fixed-width sign column

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true -- Smarter indentation for code

-- Line wrapping
opt.wrap = false -- Disable wrapping for cleaner code view
opt.linebreak = true -- Wrap at word boundaries if enabled
opt.breakindent = true -- Indent wrapped lines

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false -- Disable persistent highlight
opt.gdefault = true -- Default global substitution

-- Cursor & scrolling
opt.cursorline = true -- Highlight current line
opt.cursorlineopt = "number,line" -- Highlight only line number and line
opt.scrolloff = 8 -- Keep 8 lines visible above/below
opt.sidescrolloff = 8 -- Keep 8 columns visible on sides
opt.smoothscroll = true -- Smooth scrolling

-- Window splitting
opt.splitright = true
opt.splitbelow = true

-- Clipboard
if vim.fn.has("macunix") then
    opt.clipboard:append("unnamedplus") -- System clipboard integration
else
    opt.clipboard = "unnamedplus" -- Cross-platform clipboard
end

-- Mouse & performance
opt.mouse = "a" -- Enable mouse in all modes
opt.timeoutlen = 300 -- Faster key sequence timeout
opt.updatetime = 250 -- Faster updates
opt.redrawtime = 1500 -- Optimize for large files

-- Backups & undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undo") -- Persistent undo
opt.undolevels = 10000 -- Increase undo history

-- Appearance
opt.termguicolors = true
opt.background = "dark" -- Default to dark theme
opt.showmode = false -- Hide mode (handled by statusline)
opt.showcmd = true -- Show partial commands
opt.cmdheight = 1 -- Single line for command area
opt.laststatus = 3 -- Global statusline
opt.showtabline = 2 -- Always show tabline
opt.pumheight = 10 -- Limit completion menu height
opt.pumblend = 10 -- Slight transparency for popup menu
opt.winblend = 10 -- Slight transparency for floating windows

-- Folding (Treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1" -- Show fold indicators

-- Keyword settings
opt.iskeyword:append("-") -- Treat hyphens as part of words

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Disable line numbers in terminal",
    group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true }),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format on save",
    group = vim.api.nvim_create_augroup("AutoFormat", { clear = true }),
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Completion settings
opt.completeopt = { "menu", "menuone", "noselect" } -- Better completion UX
opt.shortmess:append("c") -- Avoid extra completion messages

-- Performance optimizations
opt.lazyredraw = true -- Reduce redraws during macros
opt.synmaxcol = 300 -- Limit syntax highlighting for long lines

-- Statuscolumn
opt.statuscolumn = "%s%=%l%C" -- Sign, line number, fold column
