local types = require("luasnip.util.types")

require 'luasnip'.config.setup({
    store_selection_keys = '<c-s>',
    history = true,
    update_events = { "TextChanged", "TextChangedI" },
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "DiagnosticWarn" } },
                hl_mode = "combine"
            }
        },
        [types.insertNode] = {
            active = {
                virt_text = { { "●", "DiagnosticInfo" } },
                hl_mode = "combine"
            }
        }
    },
})

require 'luasnip.loaders.from_vscode'.lazy_load()
