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

require("rose-pine").setup({
    variant = "auto",      -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true,        -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    pallete = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

-- vim.cmd("colorscheme gruvbox-material")
-- vim.cmd("colorscheme e-ink")
vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}

local ftMap = {
    vim = "indent",
    python = { "indent" },
    git = "",
}

for _, ls in ipairs(language_servers) do
    require("lspconfig")[ls].setup({
        capabilities = capabilities,
        -- you can add other fields for setting up lsp server in this table
    })
end
require("ufo").setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds_for_ft = {},
    preview = {
        win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
        },
        mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
        },
    },
    provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype]
    end,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set("n", "K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.fn.CocActionAsync("definitionHover") -- coc.nvim
        vim.lsp.buf.hover()
    end
end)

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })


require('neoscroll').setup({
    mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        '<C-u>', '<C-d>',
        '<C-b>', '<C-f>',
        '<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
    },
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    duration_multiplier = 1.0,   -- Global duration multiplier
    easing = 'linear',           -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
    ignored_events = {           -- Events ignored while scrolling
        'WinScrolled', 'CursorMoved'
    },
})


-- local set_hl = vim.api.nvim_set_hl
-- local mono = require("e-ink.palette").mono
-- --[[
-- {
--    "#CCCCCC",   -- 1
--    "#C2C2C2",   -- 2
--    "#B8B8B8",   -- 3
--    "#AEAEAE",   -- 4
--    "#A4A4A4",   -- 5
--    "#9A9A9A",   -- 6
--    "#909090",   -- 7
--    "#868686",   -- 8
--    "#7C7C7C",   -- 9
--    "#727272",   -- 10
--    "#686868",   -- 11
--    "#5E5E5E",   -- 12
--    "#545454",   -- 13
--    "#4A4A4A",   -- 14
--    "#474747",   -- 15
--    "#333333"    -- 16
-- }
-- ]]
--
-- local everforest = require("e-ink.palette").everforest
-- --[[
-- {
--    red1 = "#F85552",
--    red2 = "#E66868",
--    red3 = "#FFE7DE",
--    yellow1 = "#DFA000",
--    green1 = "#8DA101",
--    green2 = "#93B259",
--    green3 = "#f3f5d9",
--    blue1 = "#3A94C5",
--    blue2 = "#ECF5ED",
--    cyan1 = "#35A77C",
--    magenta1 = "#DF69BA"
-- }
-- ]]
--
-- set_hl(0, "Group", { fg = mono[15] })
-- set_hl(0, "Group", { fg = everforest.green1 })
