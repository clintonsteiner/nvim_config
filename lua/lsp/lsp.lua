local lsp = require 'lspconfig'
lsp.pylsp.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.codeActionProvider = false
        client.server_capabilities.executeCommandProvider = false
        on_attach(client, bufnr)
    end,
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
            args = {
                "--ignore=E501",
            },
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
