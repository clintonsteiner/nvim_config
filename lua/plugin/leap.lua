local leap = require('leap')
leap.add_repeat_mappings(';', ',', {
    relative_directions = true,
})
leap.opts.case_sensitive = true
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)')
vim.keymap.set({'n', 'o'}, 'S', '<Plug>(leap-backward)')
vim.keymap.set('o', 'z', '<Plug>(leap-forward-till)')
vim.keymap.set('o', 'Z', '<Plug>(leap-backward-till)')
