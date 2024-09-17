vim.keymap.set("n", "<Leader>g", "<cmd>ZenMode<CR>", { desc = "Toggle zemmode view" })

require'zen-mode'.setup{
    window = { backdrop = 1 },
    --fixes issue where BG is gray on certain colorschemes
    on_open = function(_) vim.cmd("hi ZenBg ctermbg=0") end
}
