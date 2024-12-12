local password_cache = {
    openai = nil,
    anthropic = nil
}

local main_system_prompt = [[You are an AI programming assistant named "CodeCompanion".
You are currently plugged in to the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.]]

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
    opts = {
        system_prompt = function(adapter)
            return adapter.system_prompt or main_system_prompt
        end
    },

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
        proofreader = function()
            return require"codecompanion.adapters".extend("ollama", {
                name = "proofreader",
                system_prompt = [[ You are an AI writing coach named "ProofReader".
                    You are currently plugged in to the Neovim text editor on a user's machine.

                    You can give advice about writing style. You favor clear, precise, and direct writing.
                ]]
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
                    role = "user",
                    content = "could you give me some advice on improving this text?"
                }
            },
            opts = {
                modes = { "v" },
                auto_submit = true,
                is_slash_cmd = true,
                short_name = "proofread",
                adapter = {
                    name = "proofreader",
                    model = "llama3.1",
                }
            }
        }
    },
}
