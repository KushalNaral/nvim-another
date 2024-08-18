return {
  "lvimuser/lsp-inlayhints.nvim",
  config = function()
    require('lsp-inlayhints').setup({
        only_current_line = true
    })
    vim.cmd('hi! LspInlayHint guifg=#403d52 guibg=#1f1d2e')
  end
}
