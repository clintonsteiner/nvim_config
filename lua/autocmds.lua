local group = vim.api.nvim_create_augroup("MyAutogroups", {})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank {timeout = 400}
    end,
})
