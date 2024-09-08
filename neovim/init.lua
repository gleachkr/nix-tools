-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--     vim.fn.system({
--         "git",
--         "clone",
--         "--filter=blob:none",
--         "https://github.com/folke/lazy.nvim.git",
--         "--branch=stable", -- latest stable release
--         lazypath,
--     })
-- end
-- vim.opt.rtp:prepend(lazypath)

--require("lazy").setup({
--    spec = { import = "plugins" },
--    defaults = {
--        --lazy = true
--    },
--})

vim.g.maplocalleader = ','
vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set("n", "U", vim.cmd.redo, { noremap = true, silent = true })
vim.keymap.set("n", "Q", "@q")
vim.keymap.set("n", "gx", "<cmd>terminal xdg-open '<cWORD>'<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>vimrc", function() vim.cmd.tabe("~/.config/nvim/init.lua") end,
    { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>ftrc",
    function()
        local ftrc = "~/.config/nvim/ftplugin/" .. vim.opt.filetype:get()
        if 1 == vim.fn.empty(vim.fn.glob(ftrc .. ".vim")) then
            vim.cmd.tabe(ftrc .. ".lua")
        else
            vim.cmd.tabe(ftrc .. ".vim")
        end
    end,
    { noremap = true, silent = true })
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { noremap = true, silent = true })

vim.opt.undofile = true
vim.opt.virtualedit = 'block'
vim.opt.nu = true
vim.opt.visualbell = true
vim.opt.formatoptions:append("1")
vim.opt.breakindent = true
vim.opt.termguicolors = true
vim.opt.inccommand = "split"
vim.opt.breakindentopt = "sbr"
vim.opt.showbreak = "↳ "
vim.opt.expandtab = true
vim.opt.ts = 4
vim.opt.sw = 4

vim.cmd("colo seoul256")

vim.cmd.dig("|-", 8866)   -- ⊢
vim.cmd.dig("|=", 8872)   -- ⊨
vim.cmd.dig("-|", 8867)   -- ⊣
vim.cmd.dig("|>", 8614)   -- ↦
vim.cmd.dig("0+", 0x2295) -- ⊕
vim.cmd.dig("0X", 0x2297) -- ⊗
vim.cmd.dig("-o", 0x22B8) -- ⊸
vim.cmd.dig("LO", 0x214B) -- ⅋
vim.cmd.dig("T-", 8868)   -- ⊤
vim.cmd.dig("tl", 10216)  -- ⟨
vim.cmd.dig("tr", 10217)  -- ⟩
vim.cmd.dig("[[", 10214)  -- ⟦
vim.cmd.dig("]]", 10215)  -- ⟧
vim.cmd.dig("O1", 9312)
vim.cmd.dig("O2", 9313)
vim.cmd.dig("O3", 9314)
vim.cmd.dig("O4", 9315)
vim.cmd.dig("O5", 9316)
vim.cmd.dig("O6", 9317)
vim.cmd.dig("O7", 9318)
vim.cmd.dig("O8", 9319)
vim.cmd.dig("O9", 9320)
vim.cmd.dig("ns", 0x2099) -- ₙ
vim.cmd.dig("is", 0x1d62) -- ᵢ
vim.cmd.dig("iS", 0x2071) -- ⁱ
vim.cmd.dig("js", 0x2c7c) -- ⱼ
vim.cmd.dig("jS", 0x02b2) -- ʲ
vim.cmd.dig("ks", 0x2096) -- ₖ
vim.cmd.dig("kS", 0x1D4F) -- ᵏ
vim.cmd.dig("vs", 0x1D65) -- ᵥ
vim.cmd.dig("vS", 0x1D5B) -- ᵛ
vim.cmd.dig("us", 0x1D64) -- ᵤ 

local termAutocommands = vim.api.nvim_create_augroup("TERM", { clear = true })
vim.api.nvim_create_autocmd("TermOpen",
    { pattern = '*', group = termAutocommands, callback = function() vim.opt_local.nu = false end })

local noteAutocommands = vim.api.nvim_create_augroup("NOTES", { clear = true })
vim.api.nvim_create_autocmd("BufWriteCmd", {
    pattern = 'newnote',
    group = noteAutocommands,
    callback = function()
        local name = vim.fn.fnameescape(vim.fn.getline(1))
        vim.cmd.file(name .. ".txt")
        vim.cmd.write()
    end
})

vim.api.nvim_create_user_command('Browse',
    function(opts)
        vim.fn.system { 'xdg-open', opts.fargs[1] }
    end,
    { nargs = 1 })

vim.api.nvim_create_user_command("Async",
    function(opts)
        local uv = vim.loop
        local stdout = uv.new_pipe(true)
        local stderr = uv.new_pipe(true)

        local _, pid = uv.spawn(table.remove(opts.fargs, 1), {
            stdio = { nil, stdout, stderr },
            args = opts.fargs,
            detached = false,
        })

        stdout:read_start(vim.schedule_wrap(function(err, data)
            assert(not err, err)
            if data then
                require("fidget").notify(data)
            end
        end))

        stderr:read_start(vim.schedule_wrap(function(err, data)
            assert(not err, err)
            if data then
                require("fidget").notify(data)
            end
        end))

        local function on_done()
            local _handle = io.popen("kill " .. pid)
            if _handle ~= nil then
                _handle:close()
            end
        end

        vim.api.nvim_create_autocmd("VimLeavePre", { callback = on_done })
    end, { nargs = "*" })

vim.api.nvim_create_user_command("Detach", function()
    for _, ui in pairs(vim.api.nvim_list_uis()) do
      if ui.chan and not ui.stdout_tty then
        vim.fn.chanclose(ui.chan)
      end
    end
  end, { desc = "detach from remote UI" })
