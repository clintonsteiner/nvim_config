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
g['ayucolor'] = 'mirage'
cmd 'colorscheme ayu'

g.python3_host_prog="/home/ben/.virtualenvs/nvim/bin/python3"

----------------- plugin settings --------------------------
-- ayu
function custom_ayu_colors()
    cmd 'call ayu#hi("LineNr", "fg", "")'
    cmd 'call ayu#hi("TabLineFill", "", "bg")'
    cmd 'call ayu#hi("TabLineSel", "bg", "accent", "bold")'
    cmd 'call ayu#hi("NormalMode", "string", "bg", "reverse,bold")'
    cmd 'call ayu#hi("InsertMode", "tag", "bg", "reverse,bold")'
    cmd 'call ayu#hi("VisualMode", "keyword", "bg", "reverse,bold")'
    cmd 'call ayu#hi("ReplaceMode", "markup", "bg", "reverse,bold")'
    cmd 'call ayu#hi("OtherMode", "constant", "bg", "reverse,bold")'
    cmd 'call ayu#hi("ScrollBar", "regexp", "selection_inactive")'
end

vim.api.nvim_command("augroup custom_colors")
vim.api.nvim_command("autocmd!")
cmd('autocmd ColorScheme ayu lua custom_ayu_colors()')
vim.api.nvim_command("augroup END")

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

function fzf_cd()
    local fzf_wrap = vim.fn["fzf#wrap"] 
    local wrapped = fzf_wrap("fzf_cd", {
        source = "find . -type d -follow 2>/dev/null",
        options = {
            "--prompt", "Cd> "
        }
    })
    wrapped["sink*"] = nil -- this line is required if you want to use `sink` only
    wrapped.sink = function(line)
        cmd('cd ' .. line)
    end
    fn['fzf#run'](wrapped)
end
cmd [[command! Cd lua fzf_cd{}]]

function fzf_sessions()
    local fzf_wrap = vim.fn["fzf#wrap"] 
    local wrapped = fzf_wrap("fzf_sessions", {
        source = "find ~/.local/share/nvim/session -type f",
        options = {
            "--prompt", "Sessions> "
        }
    })
    wrapped["sink*"] = nil
    wrapped.sink = function(line)
        cmd('source ' .. line)
    end
    fn['fzf#run'](wrapped)
end
cmd [[command! Sessions lua fzf_sessions{}]]

-- indentLine
g.indentLine_char = ''

-- vim-sneak
g['sneak#label'] = 1

-- floaterm
g.floaterm_autoclose = 1
g.floaterm_width = 0.9
g.floaterm_height = 0.7
g.floaterm_title = 0

-- sandwich
cmd 'runtime macros/sandwich/keymap/surround.vim'  -- use tpope's surround.vim mapping so sneak works

-------------------- statusline ----------------------------
function git()
    local branch_sign = ''
    if not g.loaded_fugitive then
        return ""
    end

    local out = fn.FugitiveHead()

    if out ~= "" then
        out = branch_sign .. " " .. out
    end

    return out
end

function get_mode()
    local mode_table = {
        n = 'normal ',
        no = 'n-operator pending ',
        v = 'visual ',
        V = 'v-line ',
        [''] = 'v-block ',
        s = 'select ',
        S = 's-line ',
        [''] = 's-block ',
        i = 'insert ',
        R = 'replace ',
        Rv = 'v-replace ',
        c = 'command ',
        cv = 'vim ex ',
        ce = 'ex ',
        r = 'prompt ',
        rm = 'more ',
        ['r?'] = 'confirm ',
        ['!'] = 'shell ',
        t = 'terminal '
    }
    local current_mode = mode_table[fn.mode()]

    return string.upper(current_mode or 'v-block')
end

function get_mode_color(mode)
  local mode_color = 'OtherMode'
  if mode == 'n' then
    mode_color = '%#NormalMode#'
  elseif mode == 'i' then
    mode_color = '%#InsertMode#'
  elseif mode == 'R' then
    mode_color = '%#ReplaceMode#'
  elseif mode == 'v' or mode == 'V' or mode == '' then
    mode_color = '%#VisualMode#'
  else
    mode_color = '%#OtherMode#'
  end
  return mode_color
end

function get_readonly_char()
  if vim.bo.readonly or vim.bo.modifiable == false then 
    return '    '
  else
    return ''
  end
end

function get_cwd()
  local dir = vim.api.nvim_call_function('getcwd', {})
  return dir
end

function scroll_bar()
  -- from github.com/drzel/vim-line-no-indicator
  local chars = {
      '   ', '▏  ', '▎  ', '▍  ', '▌  ', '▋  ', '▊  ', '▉  ', '█  ', '█▏ ', '█▎ ', '█▍ ', '█▌ ',
      '█▋ ', '█▊ ', '█▉ ', '██ ', '██▏', '██▎', '██▍', '██▌', '██▋', '██▊', '██▉', '███'
  }
  local current_line = fn.line('.')
  local total_lines = fn.line('$')
  local index = current_line
  if current_line == 1 then
    index = 1
  elseif current_line == total_lines then
    index = #chars
  else
    local line_no_fraction = math.floor(current_line) / math.floor(total_lines)
    index = math.ceil(line_no_fraction * #chars)
  end
  return chars[index]
end


function StatusLine()
    local status = ''

    status = status .. get_mode_color(fn.mode())
    status = status .. [[ %-{luaeval("get_mode()")}]]
    status = status .. '%#DiffAdd#'
    status = status .. [[ %-{luaeval("git()")}]]
    status = status .. [[ %-m %-{luaeval("get_readonly_char()")}]]
    status = status .. '%#Directory#'
    status = status .. '%='
    status = status .. [[%-{luaeval("get_cwd()")} ]]
    status = status .. [[%#ScrollBar#%-{luaeval("scroll_bar()")}]]
    status = status .. [[%#TabLine# %-"col:%2c]]

    return status
end

vim.o.showmode = false
vim.o.laststatus = 2
vim.o.statusline = '%!luaeval("StatusLine()")'
vim.o.showtabline = 2

-------------------- mappings ------------------------------
g.mapleader = ' '  -- make sure this is before all other leader mappings
map('n', '<leader>/', ':BLines<CR>')
map('n', '<leader>:', ':e ~/dotfiles/nvim/init.lua<CR>')
map('n', '<leader>;', ':so ~/dotfiles/nvim/init.lua<CR>')
map('n', '<leader>b', ':Buffers<CR>')
map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>h', ':Helptags<CR>')
map('n', '<leader>q', ':bd<CR>')
map('n', '<leader>r', ':Rg<CR>')
-- g.which_key_map['s'] = [":call SaveSession()", 'save session']
-- change dir
map('n', '<leader>cc', ':cd %:p:h<CR>')
map('n', '<leader>cd', ':Cd<CR>')
map('n', '<leader>ch', ':cd ~<CR>')

map('n', '<F1>', ':w<CR>')
map('i', '<F1>', '<ESC>:w<CR>i')
map('n', '<TAB>', '<C-^>')
map('n', '<S-TAB>', ':bn<CR>')
map('n', 'Y', 'y$')

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights

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

-- map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
-- map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
-- map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
-- map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
-- map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
-- map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
-- map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
-- map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- COMMANDS ------------------------------
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  -- disabled in visual mode
