require("ibl").setup({
    enabled = true,
    indent = {
        char = "│",
    },
    scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        -- show_exact_scope = true,
        include = {
            node_type = {
                ["*"] = {
                    "*",
                },
            },
        },
    },
    exclude = {
        filetypes = {
            "lspinfo",
            "help",
            "man",
            "gitcommit",
        },
        buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
        },
    },
})
