vim.g.maplocalleader = ','
vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set("n", "U", vim.cmd.redo, { noremap = true, silent = true })
vim.keymap.set("n", "Q", "@q")
vim.keymap.set("n", "gx", "<cmd>terminal xdg-open '<cWORD>'<cr>", { noremap = true, silent = true })
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
