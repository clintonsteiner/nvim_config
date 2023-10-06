require("ibl").setup({
    enabled = true,
    indent = {
        char = "│",
    },
    scope = {
        enabled = false,
    },
    -- scope = {
    --     show_start = false,
    --     show_end = false,
    --     enabled = true,
    --     include = {
    --         node_type = {
    --             ["*"] = {
    --                 "function",
    --                 "if",
    --             },
    --         },
    --     },
    --     exclude = {
    --         filetypes = {
    --             "lspinfo",
    --             "help",
    --             "man",
    --             "gitcommit",
    --         },
    --         buftypes = {
    --             "terminal",
    --             "nofile",
    --             "quickfix",
    --             "prompt",
    --         },
    --     },
    -- },
})
