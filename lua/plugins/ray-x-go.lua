return {
    -- Go plugin for LSP, formatting, and debugging
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- Set up Go.nvim for Go-specific LSP configuration, code formatting, and debugging
            require("go").setup({
                lsp_cfg = true,         -- Automatically set up Go LSP with gopls
                dap_debug = true,       -- Enable DAP (delve debugging)
                goimport = 'goimports', -- Use goimports as the default formatter
                gofmt = 'gofmt',        -- Use gofmt for Go code formatting
                lsp_keymaps = true,     -- Set up LSP keymaps for Go
            })

            -- DAP setup for Go (Delve Debugger)
            local dap = require("dap")
            dap.adapters.go = {
                type = "server",
                port = 38697, -- Delve default port
                executable = {
                    command = "dlv",
                    args = { "dap", "-l", "127.0.0.1:38697" },
                },
            }

            dap.configurations.go = {
                {
                    type = "go",
                    name = "Launch file",
                    request = "launch",
                    program = "${file}",
                },
                {
                    type = "go",
                    name = "Attach remote",
                    request = "attach",
                    mode = "remote",
                    port = 38697,
                },
            }

            -- DAP UI setup for better user interface (show breakpoints, stack traces, etc.)
            require("dapui").setup({
                icons = { expanded = "▾", collapsed = "▸" },
                mappings = {
                    expand = { "i", "<CR>" },
                    open = { "i", "<TAB>" },
                    remove = { "i", "d" },
                },
                layouts = {
                    {
                        elements = { "scopes", "breakpoints", "stacks", "watches" },
                        size = 40,
                        position = "left", -- Position the UI to the left side
                    },
                    {
                        elements = { "repl", "console" },
                        size = 10,
                        position = "bottom", -- Position REPL at the bottom
                    },
                },
                -- Stylizing UI for better visibility
                theme = "dark",             -- Dark theme for the UI
                border = "single",          -- Single-line border for a cleaner look
                colors = {
                    active = "#FF8800",     -- Highlight active elements in orange
                    background = "#1E1E1E", -- Background color of the UI
                    accent = "#80FF00",     -- Accent color for labels
                }
            })

            -- Virtual text for debugging
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                highlight_changed_variables = true, -- Highlight changed variables
                virt_text_pos = 'inline',           -- Inline display of variables
                show_stop_reason = true,            -- Show the stop reason when the debugger pauses
            })

            -- Mason setup for installing external tools like Delve
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "delve" }, -- Ensure Delve is installed
            })

            -- LSP setup for Go (gopls)
            require('lspconfig').gopls.setup({
                settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = true,
                    },
                },
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },

    -- Optional: Key mappings for debugging
    {
        "mfussenegger/nvim-dap",
        config = function()
            vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require"dap".continue()<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require"dap".step_over()<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require"dap".step_into()<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F12>', '<Cmd>lua require"dap".step_out()<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>db', '<Cmd>lua require"dap".toggle_breakpoint()<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>dr', '<Cmd>lua require"dap".repl.open()<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>dl', '<Cmd>lua require"dap".run_last()<CR>',
                { noremap = true, silent = true })
        end
    },
}
