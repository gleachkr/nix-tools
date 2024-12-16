local password_cache = {
    openai = nil,
    anthropic = nil
}

local writing_prompt = [[ You are an AI writing coach named "ProofReader".

Your primary function is give advice about writing style. You favor clear, precise, and direct writing. You are exceptionally skilled, sensitive to fine nuances of meaning, and take pleasure in the use of the English language.

You should pay attention to the genre, and to the audience before considering how the text might be improved.

Preseve the tone of the original, unless the tone is inappropriate. If the tone is inappropriate, warn the user and ask how to proceed.

If the original text is unclear, ask about the meaning rather than offering edits right away.

When you do offer edits, first explain how they improve the document.

]]


local function setup_adapter(api_key, adapter)
    return require"codecompanion.adapters".extend(adapter, {
        env = { api_key = api_key }
    })
end

local continue_with_adapter = function(callback, adapter)
    if not password_cache[adapter] then
        vim.ui.input({ prompt = "Enter " .. adapter .. " API key: " }, function(input)
            password_cache[adapter] = input
            callback(setup_adapter(password_cache[adapter], adapter))
        end)
    else
        callback(setup_adapter(password_cache[adapter], adapter))
    end
end

require"codecompanion".setup{
    adapters = {
        openai = function()
            local adapter
            continue_with_adapter(function(created_adapter)
                adapter = created_adapter
            end, "openai")
            return adapter
        end,
        anthropic = function()
            local adapter
            continue_with_adapter(function(created_adapter)
                adapter = created_adapter
            end, "anthropic")
            return adapter
        end,
    },

    strategies = {
        chat = {
            adapter = "openai",
            slash_commands = {
                ["buffer"] = { opts = { provider = "telescope", }, },
                ["file"] = { opts = { provider = "telescope", }, },
                ["symbols"] = { opts = { provider = "telescope", }, },
            },
        },
        inline = {
            adapter = "openai",
        },
        agent = {
            adapter = "openai",
        },
    },
    display = {
        chat = {
            window = {
                opts = {
                    number = false
                }
            }
        }
    },
    prompt_library = {
        ["Proofread"] = {
            strategy = "chat",
            description = "proofread for style",
            prompts = {
                {
                    role = "system",
                    content = writing_prompt,
                },
                {
                    role = "user",
                    content = "could you give me some advice on improving this text?"
                }
            },
            opts = {
                modes = { "v" },
                auto_submit = true,
                short_name = "proofread",
                ignore_system_prompt = true,
            }
        }
    },
}
