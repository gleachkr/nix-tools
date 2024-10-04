
local password_cache = nil

require"codecompanion".setup{
    adapters = {
        openai = function()
            if not password_cache then
                -- Retrieve password once and cache it
                password_cache = io.popen("zenity --password"):read("*line")
            end
            return require"codecompanion.adapters".extend("openai", {
                env = {
                    api_key = password_cache
                },
            })
        end,
    },

    strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        },
        agent = {
          adapter = "ollama",
        },
    },
}
