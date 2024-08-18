return{
  'numToStr/FTerm.nvim',
  opts = {--[[ things you want to change go here]]},
  config = function()

    function is_terminal_open()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buftype == 'terminal' then
          return true
        end
      end
      return false
    end

    -- UserCommands
    vim.api.nvim_create_user_command('OpenLazyGit', function()
        require('FTerm').scratch({cmd="lazygit", config={auto_close=true}})
    end, {bang = true})

    vim.api.nvim_create_user_command('ToggleOneShotTerminal', function()
      local fterm = require('FTerm');
      if is_terminal_open() then
        fterm.exit()
      else
        fterm.open()
      end
    end, {bang = true})

    require('FTerm').setup{}
    local wk = require('which-key')
    wk.register({
          t = {'<cmd>lua require("FTerm").toggle()<cr>', "Open Terminal"},
          a = {'<cmd>ToggleOneShotTerminal<cr>', "Toggle Terminal"},
          v = {'<cmd>OpenLazyGit<cr>', "Version Control (git)"},
          i = {'<cmd>lua require("FTerm").scratch({cmd="git rebase -i"})<cr>', "Rebase Interactive"}
    }, {prefix="<leader>"})
  end
}
