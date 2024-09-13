local permission_hlgroups = {
    ['-'] = 'NonText',
    ['r'] = 'Type',
    ['w'] = 'TypeDef',
    ['x'] = 'SpecialComment',
    ['s'] = 'SpecialComment',
    ['t'] = 'SpecialComment',
}

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

require("oil").setup {
    default_file_explorer = true,
    keymaps = {
        ["."] = "actions.open_cmdline",
        ["g!"] = "actions.open_terminal",
    },
    columns = {
        {
            "permissions",
            highlight = function(permission_str)
                local hls = {}
                for i = 1, #permission_str do
                    local char = permission_str:sub(i, i)
                    table.insert(hls, { permission_hlgroups[char], i - 1, i })
                end
                return hls
            end,
        },
        { "size",  highlight = 'Special' },
        { "mtime", highlight = 'Number' },
        { "icon",  highlight = 'Special' },
    },
    win_options = {
        number = false,
        relativenumber = false,
        signcolumn = 'no',
        foldcolumn = '0',
        statuscolumn = '',
        cursorline = true,
    },
}
