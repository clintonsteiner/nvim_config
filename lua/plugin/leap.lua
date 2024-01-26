local leap = require('leap')
leap.create_default_mappings()
leap.add_repeat_mappings(';', ',', {
    relative_directions = true,
})
leap.opts.case_sensitive = true
vim.keymap.set('o', 'z', '<Plug>(leap-forward-to)')
vim.keymap.set('o', 'Z', '<Plug>(leap-backward-to)')
