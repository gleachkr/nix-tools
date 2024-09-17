local function obsessionPrepend ()
    local body = vim.fn.readfile(vim.g.this_obsession)
    local newbody = vim.fn.insert(body, '#!/bin/env -S nvim -S')
    vim.fn.writefile(newbody, vim.g.this_obsession)
    vim.fn.jobstart({"chmod","+x",vim.g.this_obsession})
end

local obsessionAutocommands = vim.api.nvim_create_augroup("OBSESSION", {clear = true})
vim.api.nvim_create_autocmd("User", {
    pattern = 'Obsession',
    group = obsessionAutocommands,
    callback = obsessionPrepend
})
