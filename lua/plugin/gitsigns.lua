require('gitsigns').setup({
    signs = {
        delete = {text = '┃'},
        -- delete = {text = '█'},  -- experiment...
        changedelete = {hl = 'GitSignsChangeDelete', text = '┃'},
    },
    signs_staged = {
        delete = {text = '┃'},
        changedelete = {hl = 'GitSignsChangeDelete', text = '┃'},
    },
    current_line_blame_formatter = '<abbrev_sha> <summary> <author> <author_time:%Y-%m-%d>',
    -- _signs_staged_enable = true,
    signs_staged_enable = false,  -- still way too buggy even though it's on by default
})
