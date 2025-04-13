return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        require("lualine").setup({
            options = {
                -- theme = "gruvbox-material",
                theme = "e-ink",
            },
            sections = {
                lualine_c = { { "filename", file_status = true, path = 1 } },
            },
        })
    end,
}
