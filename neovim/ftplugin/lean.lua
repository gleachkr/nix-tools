vim.wo.signcolumn = "yes"

vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>g", ":LeanGoal<cr>", {})
vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>i", ":LeanInfoviewToggle<cr>", {})

local function count_lean_windows()
  local tab_wins = vim.api.nvim_tabpage_list_wins(0)
  local lean_wins = vim.tbl_filter(function (w)
    local buf = vim.api.nvim_win_get_buf(w)
    local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    return buf_ft == 'lean'
  end, tab_wins)
  return #lean_wins
end

--autoclose the infoview IF

--You quit the last lean window
vim.api.nvim_create_autocmd({'QuitPre'}, {
  pattern = {'*.lean'},
  callback = function ()
    local infoview = require('lean.infoview').get_current_infoview()
    if infoview and count_lean_windows() <= 1 then
        infoview:close()
    end
  end
})

--You enter a new buffer and no lean windows remain visible
vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  callback = function ()
    local infoview = require('lean.infoview').get_current_infoview()
    if infoview and count_lean_windows() == 0 then
        infoview:close()
    end
  end
})
