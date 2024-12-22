return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("trouble").setup {
        }

        local wk = require('which-key')
        wk.register({
            x = {
                name = "Trouble",
                x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
                w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble Workspace" },
                d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble Document" },
                q = { "<cmd>TroubleToggle quickfix<cr>", "Trouble Quickfix" },
            },
        }, { prefix = "<leader>t" })
    end
}
