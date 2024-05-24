require('leap').opts.case_sensitive = true
require('leap.user').set_repeat_keys('<cr>', '<bs>', {
    relative_directions = true,
})
vim.keymap.set('n', 's', '<Plug>(leap)')
vim.keymap.set({'x', 'o'}, 's', '<Plug>(leap-forward)')
vim.keymap.set({'n', 'o'}, 'S', '<Plug>(leap-backward)')  -- not mapped to visual mode (x); mapping clashes
vim.keymap.set('o', 'z', '<Plug>(leap-forward-till)')
vim.keymap.set('o', 'Z', '<Plug>(leap-backward-till)')
