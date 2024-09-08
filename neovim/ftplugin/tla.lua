vim.api.nvim_create_user_command('Check',
    function()
        local filename = vim.fn.expand('%')
        vim.cmd.tabnew()
        vim.cmd.terminal('tlc ' .. filename)
    end,
{})

local TLAAutocommands = vim.api.nvim_create_augroup("TLA", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.tla',
    group = TLAAutocommands,
    callback = function()
        local filename = vim.fn.expand('%')
        vim.cmd("below 20new")
        vim.cmd.terminal('tlasany ' .. filename)
    end
})
