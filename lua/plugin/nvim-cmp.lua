local cmp = require'cmp'
local kind_icons = {
    Text = "",
    Method = "",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "𝒙",
    Class = "",
    Interface = "󰆧",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "󰘍",
    Color = "",
    File = "",
    Reference = "󰌹",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      -- Source
      vim_item.menu = ({
        buffer = "[buffer]",
        nvim_lsp = "[lsp]",
        nvim_lua = "[lua]",
        path = "[path]",
        cmdline = "[cmdline]",
        rg = "[rg]",
      })[entry.source.name]
      return vim_item
    end
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- manually trigger the ripgrep completion source when needed
vim.keymap.set("i", "<c-x><c-r>", function()
  require("cmp").complete({
    config = {
      sources = {
        {
          name = "rg",
          -- keyword_length = 3,
        },
      },
    },
  })
end)
