require"codecompanion".setup{
    adapters = {
        openai = function()
            return require"codecompanion.adapters".extend("openai", {
                env = {
                    api_key = "cmd:zenity --password" -- need caching functionality here somehow
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
