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

g.python3_host_prog="/home/ben/.virtualenvs/nvim/bin/python3"

-------------------- statusline ----------------------------
-- vim.o.statusline = table.concat({
--     '  ',
--     'f',            -- relative path
--     'm',            -- modified flag
--     'r',
--     '=',
--     '{&spelllang}',
--     'y',            -- filetype
--     '8(%l,%c%)',    -- line, column
--     '8p%% ',        -- file percentage
-- }, ' %')
local mode_fn = vim.fn.mode
local win_getid = vim.fn.win_getid
local winbufnr_fn = vim.fn.winbufnr
local bufname_fn = vim.fn.bufname
local fnamemod_fn = vim.fn.fnamemodify
local winwidth_fn = vim.fn.winwidth
local pathshorten_fn = vim.fn.pathshorten

local function vcs()
    local branch_sign = ''
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == '' then return '' end
    local added = git_info.added and ('+' .. git_info.added .. ' ') or ''
    local modified = git_info.changed and ('~' .. git_info.changed .. ' ') or ''
    local removed = git_info.removed and ('-' .. git_info.removed .. ' ') or ''
    local pad = ((added ~= '') or (removed ~= '') or (modified ~= '')) and ' ' or ''
    local diff_str = string.format('%s%s%s%s', added, removed, modified, pad)
    return string.format('%s%s %s ', diff_str, branch_sign, git_info.head)
end

local mode_table = {
    n = '  normal ',
    no = '  n-operator pending ',
    v = '  visual ',
    V = '  v-line ',
    [''] = '  v-block ',
    s = '  select ',
    S = '  s-line ',
    [''] = '  s-block ',
    i = '  insert ',
    R = '  replace ',
    Rv = '  v-replace ',
    c = '  command ',
    cv = '  vim ex ',
    ce = '  ex ',
    r = '  prompt ',
    rm = '  more ',
    ['r?'] = '  confirm ',
    ['!'] = '  shell ',
    t = '  terminal '
}

local function get_mode(mode) return string.upper(mode_table[mode] or 'v-block') end

local function filename(buf_name, win_id)
  local base_name = fnamemod_fn(buf_name, [[:~:.]])
  local space = math.min(50, math.floor(0.4 * winwidth_fn(win_id)))
  if string.len(base_name) <= space then
    return base_name
  else
    return pathshorten_fn(base_name)
  end
end

local function update_colors(mode)
  local mode_color = 'OtherMode'
  if mode == 'n' then
    mode_color = 'NormalMode'
  elseif mode == 'i' then
    mode_color = 'InsertMode'
  elseif mode == 'R' then
    mode_color = 'ReplaceMode'
  elseif mode == 'v' or mode == 'V' or mode == '^V' then
    mode_color = 'VisualMode'
  -- elseif mode == 'c' then
  --   mode_color = 'StatuslineConfirmAccent'
  -- elseif mode == 't' then
  --   mode_color = 'StatuslineTerminalAccent'
  else
    mode_color = 'OtherMode'
  end

  local filename_color
  if vim.bo.modified then
    filename_color = 'InsertMode'
  else
    filename_color = 'NormalMode'
  end
  return mode_color, filename_color
end

local function set_modified_symbol(modified)
  if modified then
    return '  ●'
  else
    return ''
  end
end

local function get_readonly_char()
  if vim.bo.readonly or vim.bo.modifiable == false then 
    return '    '
  else
    return ''
  end
end

local statusline_format =
  '%%#%s# %s %%#StatuslineFiletype# %%#NormalMode#%s%%#%s# %s%s%%<%%#%s# %s%%<%%=%%#StatuslineVC#%s %%#StatuslineFiletype#'

local function status(win_num)
  local mode = mode_fn()
  local win_id = win_getid(win_num)
  local buf_nr = winbufnr_fn(win_id)
  local bufname = bufname_fn(buf_nr)
  local filename_segment = filename(bufname, win_id)
  local mode_color, filename_color = update_colors(mode)
  local line_col_segment = filename_segment ~= '' and
                             ' %#StatuslineLineCol#| %l:%#StatuslineLineCol#%c ' or ''
  return string.format(statusline_format, mode_color, get_mode(mode),
                       set_modified_symbol(vim.bo.modified), filename_color, filename_segment,
                       line_col_segment, filename_color, get_readonly_char(), vcs())
end

local function update()
    for i = 1, vim.fn.winnr('$')
        do vim.wo.statusline = status(i)
        end
    return {status = status, update = update}
end

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

