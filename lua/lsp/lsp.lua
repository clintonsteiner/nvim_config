local lsp = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.pylsp.setup {
    root_dir = lsp.util.root_pattern('.git', vim.fn.getcwd()),  -- start LSP server at project root or cwd
    cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/pylsp'},
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                ruff = {
                    enabled = true,
                    executable = vim.env.HOME .. '/.virtualenvs/nvim/bin/ruff',
                    ignore = {"E501"},  -- ignore line length error
                    extendSelect = {"W291", "W293"},  -- whitespace warnings
                    -- TODO add to extendSelect when available: E1120, ...
                    -- see astral-sh / ruff / issues / 970
                },
            },
        },
    },
}
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
})
