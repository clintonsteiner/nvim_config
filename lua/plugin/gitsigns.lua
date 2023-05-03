require('gitsigns').setup({
    signs = {
        delete = {text = '┃'},
        -- delete = {text = '█'},  -- experiment...
        changedelete = {hl = 'GitSignsChangeDelete', text = '┃'},
    },
    current_line_blame_formatter = '<abbrev_sha> <summary> <author> <author_time:%Y-%m-%d>',
    _inline2 = true,
})
