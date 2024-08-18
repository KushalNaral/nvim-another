return{
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    {'williamboman/mason-lspconfig.nvim'},

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},
    {'L3MON4D3/LuaSnip',
      dependencies={"rafamadriz/friendly-snippets"}
    },
    {"lvimuser/lsp-inlayhints.nvim"}
    -- {"simrat39/rust-tools.nvim"}
  },
  config = function()
    local lsp = require('lsp-zero').preset({})

    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({buffer = bufnr})
    end)

    local hints = require('lsp-inlayhints')
    local lspconfig = require('lspconfig')

    lspconfig.lua_ls.setup({
      on_attach = function(client, bufnr)
        hints.on_attach(client, bufnr)
      end,
      settings = {
        Lua = {
          hint = {
            enable = true,
          }
        }
      }
    })

    lspconfig.rust_analyzer.setup({
      on_attach = function(client, bufnr)
        hints.on_attach(client, bufnr)
      end,
      settings = {
        ["rust-analyzer"] = {
          inlayHints = {
            enable = false,
          }
        }
      }
    })

    lspconfig.tsserver.setup({
      on_attach = function(client, bufnr)
        hints.on_attach(client, bufnr)
      end,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        }
      }
    })

    lsp.setup()

    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()

    local select_ops = { behavior = cmp.SelectBehavior.Select }
    require('luasnip.loaders.from_vscode').lazy_load()

    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
    end

    cmp.setup({
      sources = {
        {name = 'copilot', keyword_length = 2},
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2}
      },
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({select=true}),
        ['<C-l'] = cmp_action.luasnip_jump_forward(),
        ['<C-h>'] = cmp_action.luasnip_jump_backward(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-j>'] = cmp.mapping.select_next_item(select_ops),
        ['<C-k>'] = cmp.mapping.select_prev_item(select_ops),
        ['<Down>'] = cmp.mapping.scroll_docs(4),
        ['<Up>'] = cmp.mapping.scroll_docs(-4),
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          -- require("copilot_cmp.comparators").prioritize,

          -- Below is the default comparitor list and order for nvim-cmp
          cmp.config.compare.offset,
          -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
    })
  end
}
