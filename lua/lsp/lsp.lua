local lsp = require 'lspconfig'
-- lsp.ccls.setup {}  -- default settings; use this for cpp
lsp.pylsp.setup {
    root_dir = lsp.util.root_pattern('.git', vim.fn.getcwd()),  -- start LSP server at project root or cwd
    cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/pylsp'},
    settings = {
        pylsp = {
            plugins = {
                flake8 = {enabled = false},
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
            }
        }
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = function() end,
    }
}
lsp.ruff_lsp.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end,
    -- root_dir = lsp.util.root_pattern('.git', vim.fn.getcwd()),
    cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/ruff-lsp'},
    init_options = {
        settings = {
            -- path = {vim.env.HOME .. '/.virtualenvs/nvim_coq/bin/ruff-lsp'},
            args = {},
        },
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = false,
                underline = false,
            }
        )
    },
}
