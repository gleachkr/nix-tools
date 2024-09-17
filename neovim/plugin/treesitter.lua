require("nvim-treesitter.configs").setup {

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- we disable latex since it kinda messes up conceals ATM
        disable = { "latex" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    }
}
