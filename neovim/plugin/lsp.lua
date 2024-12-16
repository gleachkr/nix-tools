-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end
--setup neodev

require("neodev").setup()

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local generic = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}

require 'lspconfig'.bashls.setup(generic)
require 'lspconfig'.clangd.setup(generic)
require 'lspconfig'.cssls.setup(generic)
require 'lspconfig'.dafny.setup(generic)
require 'lspconfig'.hls.setup(generic)
require 'lspconfig'.html.setup(generic)
require 'lspconfig'.jedi_language_server.setup(generic)
require 'lspconfig'.jsonls.setup(generic)
require 'lspconfig'.lua_ls.setup(generic)
require 'lspconfig'.nil_ls.setup(generic)
require 'lspconfig'.ocamllsp.setup(generic)
require 'lspconfig'.pylsp.setup(generic)
require 'lspconfig'.rust_analyzer.setup(generic)
require 'lspconfig'.texlab.setup(generic)
require 'lspconfig'.ts_ls.setup(generic)
-- require 'coq-lsp'.setup {
--     lsp = {
--         on_attach = on_attach,
--         init_options = {
--             show_notices_as_diagnostics = true,
--         }
--     }
-- }
