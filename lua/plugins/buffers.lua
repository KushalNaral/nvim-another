return{
  "famiu/bufdelete.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function ()
    local wk = require("which-key");
    wk.register({
      ["<leader>"] = {"<C-^><cr>", "alternate file"},
      b = {
        name = "+Buffers",
        b = {"<cmd>Telescope buffers<cr>", "Buffers"},
        d = {"<cmd>Bdelete<cr>", "Delete"},
        l = {"<cmd>bnext<cr>", "next"},
        h = {"<cmd>bprevious<cr>", "back"},
      }
    },
      {prefix="<leader>"})
  end
}
