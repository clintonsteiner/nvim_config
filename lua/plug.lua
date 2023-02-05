local Plug = vim.fn['plug#']
vim.g.plug_home = vim.fn.stdpath('config') .. '/plugged'

vim.call('plug#begin')
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'shougo/deoplete-lsp'
Plug('shougo/deoplete.nvim', {['do'] = vim.fn['remote#host#UpdateRemotePlugins']})
Plug 'neovim/nvim-lspconfig'
Plug 'ibhagwan/fzf-lua'
Plug 'Shatur/neovim-ayu'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-commentary'
Plug 'kylechui/nvim-surround'
Plug 'justinmk/vim-sneak'
Plug 'voldikss/vim-floaterm'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'yioneko/nvim-yati'
Plug 'echasnovski/mini.map'
vim.call('plug#end')    -- automatically calls `filetype plugin indent on` and `syntax enable`
