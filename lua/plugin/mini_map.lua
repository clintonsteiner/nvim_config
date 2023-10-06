local map = require('mini.map')
map.setup({
    integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.gitsigns(),
        map.gen_integration.diagnostic(),
    },
    symbols = {
        encode = map.gen_encode_symbols.dot('4x2'),
    },
    window = {
        focusable = true,
        show_integration_count = false,
    },
})
