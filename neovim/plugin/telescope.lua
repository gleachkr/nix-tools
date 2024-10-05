local opts = {
    defaults = {
        prompt_prefix = "   ",
    },
    extensions = {
        fzf = {
            fuzzy = true,                      -- false will only do exact matching
            override_generic_sorter = true,    -- override the generic sorter
            override_file_sorter = true,       -- override the file sorter
            case_mode = "smart_case",          -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
    }
}

require('telescope').setup(opts)
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require("telescope.pickers.layout_strategies").buffer_window = function(self)
    local layout = require("telescope.pickers.window").get_initial_window_options(self)
    local prompt = layout.prompt
    local results = layout.results
    local preview = layout.preview
    local config = self.layout_config
    local padding = self.window.border and 2 or 0
    local width = vim.api.nvim_win_get_width(self.original_win_id)
    local height = vim.api.nvim_win_get_height(self.original_win_id)
    local pos = vim.api.nvim_win_get_position(self.original_win_id)
    local wline = pos[1] + 1
    local wcol = pos[2] + 1

    -- Height
    prompt.height = 1
    preview.height = self.previewer and math.floor(height * 0.4) or 0
    results.height = height
    - padding
    - (prompt.height + padding)
    - (self.previewer and (preview.height + padding) or 0)

    -- Line
    local rows = {}
    local mirror = config.mirror == true
    local top_prompt = config.prompt_position == "top"
    if mirror and top_prompt then
        rows = { prompt, results, preview }
    elseif mirror and not top_prompt then
        rows = { results, prompt, preview }
    elseif not mirror and top_prompt then
        rows = { preview, prompt, results }
    elseif not mirror and not top_prompt then
        rows = { preview, results, prompt }
    end

    local next_line = wline + padding / 2
    for _, v in pairs(rows) do
        if v.height ~= 0 then
            v.line = next_line
            next_line = v.line + padding + v.height
        end
    end

    -- Width
    prompt.width = width - padding
    results.width = prompt.width
    preview.width = prompt.width

    -- Col
    prompt.col = wcol + padding / 2
    results.col = prompt.col
    preview.col = prompt.col

    if not self.previewer then
        layout.preview = nil
    end

    return layout
end

vim.api.nvim_create_user_command("History", function() require("telescope.builtin").oldfiles() end, {})

vim.keymap.set("n", "<Leader>b", function()
        require('telescope.builtin').buffers({
            layout_strategy = 'buffer_window',
            layout_config = {
                prompt_position = "top",
            },
            sorting_strategy = "ascending",
            previewer = false,
            border = false,
            attach_mappings = function(_, map)
                map({ "i", "n" }, "<C-d>", function(prompt_bufnr)
                    local action_state = require("telescope.actions.state")
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    require('telescope.actions').delete_buffer(prompt_bufnr)
                    if pcall(function() picker:full_layout_update() end) then else
                    --we can't properly update layout if we nuke our reference
                    --buffer, so we use a protected call to bail out in that
                    --case
                    require('telescope.actions').close(prompt_bufnr)
                end
            end)
            map({ "i", "n" }, "<esc>", require('telescope.actions').close)

            return true
        end,
    })
end, { desc = "Telescope buffer selection" })
