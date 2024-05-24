require('leap').opts.case_sensitive = true
require('leap.user').set_repeat_keys('<cr>', '<bs>', {
    relative_directions = true,
})
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)')
vim.keymap.set({'n', 'o'}, 'S', '<Plug>(leap-backward)')
vim.keymap.set('o', 'z', '<Plug>(leap-forward-till)')
vim.keymap.set('o', 'Z', '<Plug>(leap-backward-till)')
