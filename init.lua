------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt=true}    -- paq-nvim manages itself
paq 'shougo/deoplete-lsp'
paq {'shougo/deoplete.nvim', run=fn['remote#host#UpdateRemotePlugins']}
paq 'nvim-treesitter/nvim-treesitter'
paq 'neovim/nvim-lspconfig'
paq {'junegunn/fzf', run=fn['fzf#install']}
paq 'junegunn/fzf.vim'
paq 'ojroques/nvim-lspfuzzy'
paq 'luxed/ayu-vim'
paq 'tpope/vim-fugitive'
paq 'Yggdroot/indentLine'
paq 'tpope/vim-commentary'
paq 'machakann/vim-sandwich'
paq 'justinmk/vim-sneak'
paq 'voldikss/vim-floaterm'

-------------------- options -------------------------------
opt('b', 'expandtab', true)
opt('b', 'shiftwidth', 4)
opt('b', 'tabstop', 4)
opt('b', 'textwidth', 100)
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- completion options (for deoplete)
opt('o', 'clipboard', 'unnamedplus')
opt('o', 'hidden', true)  -- enable modified buffers in background
opt('o', 'ignorecase', true)
opt('o', 'inccommand', 'nosplit')  -- visually show live substitutions
opt('o', 'lazyredraw', true)
opt('o', 'mouse', 'a')
opt('o', 'showmode', false)  -- not necessary with a statusline set
opt('o', 'smarttab', true)
opt('o', 'startofline', false)
opt('o', 'termguicolors', true)
opt('o', 'ttimeoutlen', 10)
opt('o', 'updatetime', 100)
opt('w', 'colorcolumn', '100')
opt('w', 'cursorline', true)
opt('w', 'number', true)
opt('w', 'relativenumber', true)
opt('w', 'wrap', false)

cmd('filetype plugin on')
cmd 'colorscheme ayu'

vim.o.statusline = table.concat({
    '  ',
    'f',            -- relative path
    'm',            -- modified flag
    'r',
    '=',
    '{&spelllang}',
    'y',            -- filetype
    '8(%l,%c%)',    -- line, column
    '8p%% ',        -- file percentage
}, ' %')

-------------------- MAPPINGS ------------------------------
g.python3_host_prog="/home/ben/.virtualenvs/nvim/bin/python3"

-------------------- mappings ------------------------------
-- map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('n', '<F1>', ':w<CR>')
map('i', '<F1>', '<ESC>:w<CR>i')
map('n', '<TAB>', '<C-^>')
map('n', '<S-TAB>', ':bn<CR>')
map('n', 'Y', 'y$')

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

----------------- plugin settings --------------------------
-- ayu
local function custom_ayu_colors()
    cmd 'ayu#hi("LineNr", "fg", "")'
    cmd 'ayu#hi("TabLineFill", "", "bg")'
    cmd 'ayu#hi("TabLineSel", "bg", "accent", "bold")'
    cmd 'ayu#hi("NormalMode", "string", "bg", "reverse,bold")'
    cmd 'ayu#hi("InsertMode", "tag", "bg", "reverse,bold")'
    cmd 'ayu#hi("VisualMode", "keyword", "bg", "reverse,bold")'
    cmd 'ayu#hi("ReplaceMode", "markup", "bg", "reverse,bold")'
    cmd 'ayu#hi("OtherMode", "constant", "bg", "reverse,bold")'
    cmd 'ayu#hi("ScrollBar", "regexp", "selection_inactive")'
end
-- augroup custom_colors
--   autocmd!
--   autocmd ColorScheme ayu call s:custom_ayu_colors()
-- augroup END

-- deoplete
g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup

-- fzf
g.fzf_layout = {
    window = {
        width = 0.9, height = 0.6
    }
}
g.fzf_colors = {
    fg = {'fg', 'Normal'},
    hl = {'fg', 'Constant'},
    ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
    ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
    ['hl+'] = {'fg', 'Statement'},
    info = {'fg', 'PreProc'},
    prompt = {'fg', 'Conditional'},
    pointer = {'fg', 'Exception'},
    marker = {'fg', 'Keyword'},
    spinner = {'fg', 'Label'},
    header = {'fg', 'Comment'}
}

-- indentLine
g.indentLine_char = ''

-- vim-sneak
g['sneak#label'] = 1

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'python', highlight = {enable = true}}

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

-- For ccls we use the default settings
lsp.ccls.setup {}
-- root_dir is where the LSP server will start: here at the project root otherwise in current folder
lsp.pyls.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- COMMANDS ------------------------------
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  -- disabled in visual mode

