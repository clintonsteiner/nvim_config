local lsp = require 'lspconfig'
lsp.pylsp.setup {
    root_dir = lsp.util.root_pattern('.git', vim.fn.getcwd()),  -- start LSP server at project root or cwd
    cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/pylsp'},
    settings = {
        pylsp = {
            plugins = {
                ruff = {
                    enabled = true,
                    executable = vim.env.HOME .. '/.virtualenvs/nvim/bin/ruff',
                    ignore = {"E501"},  -- ignore line length error
                    extendSelect = {"W291", "E302"},  -- W291: report on trailing whitespace; E302: expected 2 lines
                },
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
