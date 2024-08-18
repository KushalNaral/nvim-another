return {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      {"nvim-tree/nvim-web-devicons"},
      {"nvim-treesitter/nvim-treesitter"},
      {"VonHeikemen/lsp-zero.nvim"}, -- zero needs to be there
    },
    config = function()
        require("lspsaga").setup({
            finder = {
              keys = {
                toggle_or_open = '<cr>',
              }
            },
            outline = {
              keys = {
                toggle_or_open = '<cr>',
              }
            }
        })
        local wk = require('which-key')

        wk.register({
            F = {"<cmd>lua vim.lsp.buf.format()<cr>", "Format Buffer"},
            g = {
              name = "+LSP",
              g = {"<cmd>Lspsaga finder def+imp+ref <cr>", "lsp finder"},
              r = {"<cmd>Lspsaga rename<cr>", "Rename"},
              a = {"<cmd>Lspsaga code_action<cr>", "Code action"},
              p = {"<cmd>Lspsaga peek_definition<cr>", "Peek definition"},
              d = {"<cmd>Lspsaga goto_definition<cr>", "Goto definition"},
              o = {"<cmd>Lspsaga outline<cr>", "File Outline"},
              n = {"<cmd>lua vim.diagnostic.goto_next()<cr>", "Goto next diagnostic"}
            }
        }, {prefix="<leader>"})

    end,
}
