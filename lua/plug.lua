local Plug = vim.fn['plug#']
vim.g.plug_home = vim.fn.stdpath('config') .. '/plugged'

vim.call('plug#begin')
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'ibhagwan/fzf-lua'
Plug 'Shatur/neovim-ayu'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kylechui/nvim-surround'
Plug 'ggandor/leap.nvim'
Plug 'numToStr/FTerm.nvim'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'echasnovski/mini.map'
vim.call('plug#end')    -- automatically calls `filetype plugin indent on` and `syntax enable`
