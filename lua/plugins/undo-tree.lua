return{
  'mbbill/undotree',
  config = function()
    local wk = require('which-key')
    wk.register({
      u = {"<cmd>UndotreeToggle<cr>","Undo Tree"}
    }, {prefix="<leader>u"})
  end
}
