vim.wo.signcolumn = "yes"

vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>g", ":LeanGoal<cr>", {})
vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>i", ":LeanInfoviewToggle<cr>", {})

vim.api.nvim_create_autocmd({'QuitPre', 'BufWinLeave'}, {
  pattern = {'*.lean'},
  callback = function ()
    local infoview = require('lean.infoview').get_current_infoview()
    if infoview then
      local tab_wins = vim.api.nvim_tabpage_list_wins(0)
      local lean_wins = vim.tbl_filter(function (w)
        local buf = vim.api.nvim_win_get_buf(w)
        local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        return buf_ft == 'lean'
      end, tab_wins)
      if #lean_wins <= 1 then
        infoview:close()
      end
    end
  end
})
