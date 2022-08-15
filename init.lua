-- plugins -----------------------------------------------------------------------------------------
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'shougo/deoplete-lsp'
Plug('shougo/deoplete.nvim', {['do'] = vim.fn['remote#host#UpdateRemotePlugins']})
Plug 'neovim/nvim-lspconfig'
Plug 'ibhagwan/fzf-lua'
Plug 'Shatur/neovim-ayu'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-sandwich'
Plug 'justinmk/vim-sneak'
Plug 'voldikss/vim-floaterm'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'Vimjas/vim-python-pep8-indent'
vim.call('plug#end')    -- automatically calls `filetype plugin indent on` and `syntax enable`

-- options -----------------------------------------------------------------------------------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.textwidth = 100
vim.opt.completeopt = {'menuone,noinsert,noselect'}  -- completion options (for deoplete)
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.lazyredraw = true
vim.opt.mouse = 'a'
vim.opt.shortmess:append({c = true})  -- ignore completions messages
vim.opt.showmode = false  -- not necessary with a statusline set
vim.opt.updatetime = 1000
vim.opt.colorcolumn = '100'
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = false

vim.g.python3_host_prog = vim.env.HOME .. "/.virtualenvs/nvim/bin/python3"
vim.g.mapleader = ' '

vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {timeout=400}'  -- yank highlights

-- plugin settings ---------------------------------------------------------------------------------
-- autopairs
require('nvim-autopairs').setup()

-- ayu
local colors = require('ayu.colors')
colors.generate(true)  -- pass true to enable mirage
require('ayu').setup({
    mirage = true,
    overrides = {
        LineNr = {fg = colors.comment},
        TabLineFill = {bg = colors.bg},
        TabLineSel = {fg = colors.bg, bg = colors.accent, bold = true},
        NormalMode = {fg = colors.string, bg = colors.bg, reverse = true, bold = true},
        InsertMode = {fg = colors.tag, bg = colors.bg, reverse = true, bold = true},
        VisualMode = {fg = colors.keyword, bg = colors.bg, reverse = true, bold = true},
        ReplaceMode = {fg = colors.markup, bg = colors.bg, reverse = true, bold = true},
        OtherMode = {fg = colors.constant, bg = colors.bg, reverse = true, bold = true},
        ScrollBar = {fg = colors.accent, bg = colors.selection_inactive},
        Sneak = {fg = colors.bg, bg = colors.error, bold = true},
        GitSignsChangeDelete = {fg = colors.constant},
        TSVariableBuiltin = {fg = colors.constant, italic = true},
    }
})
require('ayu').colorscheme()

-- deoplete
vim.g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true, noremap = true})

-- floaterm
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.7
vim.g.floaterm_title = 0

-- fzf-lua
require'fzf-lua'.setup {
    fzf_colors = {
        ['hl'] = {'fg', 'Underlined'},
        ['bg+'] = {'bg', 'CursorLine'},
        ['hl+'] = {'fg', 'Statement'},
        ['info'] = {'fg', 'PreProc'},
        ['prompt'] = {'fg', 'Conditional'},
        ['pointer'] = {'fg', 'Exception'},
        ['marker'] = {'fg', 'Keyword'},
        ['spinner'] = {'fg', 'Label'},
        ['header'] = {'fg', 'Comment'}
    },
}
vim.api.nvim_command('FzfLua register_ui_select')

-- gitsigns
require('gitsigns').setup({
    signs = {
        delete = {text = '┃'},
        changedelete = {hl = 'GitSignsChangeDelete', text = '┃'},
    },
    current_line_blame_formatter = '<abbrev_sha> <summary> <author> <author_time:%Y-%m-%d>',
})

-- indent_blankline
require("indent_blankline").setup()
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')

-- lsp
local lsp = require 'lspconfig'
-- lsp.ccls.setup {}  -- default settings; use this for cpp
lsp.pylsp.setup {
    root_dir = lsp.util.root_pattern('.git', vim.fn.getcwd()),  -- start LSP server at project root or cwd
    cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/pylsp'},
    settings = {
        pylsp = {
            configurationSources = {'flake8'},
            plugins = {
                flake8 = {enabled = true, executable = vim.env.HOME .. '/.virtualenvs/nvim/bin/flake8'},
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
            }
        }
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = false,
                underline = false,
            }
        )
    }
}

-- sandwich
vim.cmd 'runtime macros/sandwich/keymap/surround.vim'  -- use tpope's surround.vim mapping so sneak works

-- sneak
vim.g['sneak#label'] = 1

-- treesitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'python', highlight = {enable = true}}

-- which-key
local wk = require("which-key")
wk.register({
    ['<CR>'] = {"<cmd>noh<CR><CR>", "remove highlights"},
    ['<Tab>'] = {"<C-^>", "last buffer"},
    ['<S-Tab>'] = {":bn<CR>", "next buffer"},
})
wk.register({
    ['/'] = {"<cmd>lua require('fzf-lua').blines()<CR>", "blines"},
    ['?'] = {"<cmd>lua require('fzf-lua').lines()<CR>", "lines"},
    [':'] = {":e ~/dotfiles/nvim/init.lua<CR>", "open init"},
    b = {"<cmd>lua require('fzf-lua').buffers()<CR>", "buffers"},
    h = {"<cmd>lua require('fzf-lua').help_tags()<CR>", "help"},
    q = {":bd<CR>", "delete buffer"},
    r = {"<cmd>lua require('fzf-lua').live_grep()<CR>", "rg"},
    s = {":lua SaveSession()<CR>", "save session"},
    w = {":w<CR>", "save"},
    c = {name = "change dir",
        c = {":cd %:p:h<CR>", "change dir cwd"},
        d = {"<cmd>lua require('fzf-lua').fzf_exec([[(echo '..' ; echo '-' ; echo '~' ; find . -type d -follow 2>/dev/null)]], {prompt = 'Cd> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('cd ' .. selected[1]) end}})<CR>", "change dir"},
    },
    g = {name = "git",
        b = {"<cmd>lua require('gitsigns').blame_line{full=true}<CR>", "blame"},
        c = {":FloatermNew<CR>git commit<CR>", "commit"},
        d = {":Gitsigns diffthis<CR>", "diff"},
        g = {"<cmd>lua require('fzf-lua').git_status()<CR>", "status"},
        j = {"<cmd>Gitsigns next_hunk<CR>", "next hunk"},
        k = {"<cmd>Gitsigns prev_hunk<CR>", "prev hunk"},
        l = {"<cmd>lua require('fzf-lua').git_bcommits({cmd = [[git log --color=always --pretty=format:%C\\(auto\\)%h\\ %s\\ %C\\(green\\)%cs\\ %an]], actions = {['default'] = function(selected) git_show_diff(selected) end}})<CR>", "log"},
        p = {"<cmd>Gitsigns preview_hunk<CR>", "preview hunk"},
        s = {":Gitsigns stage_hunk<CR>", "stage hunk"},
        t = {"<cmd>lua require('fzf-lua').git_stash()<CR>", "stash list"},
        u = {":Gitsigns reset_hunk<CR>", "undo hunk"},
    },
    i = {name = "insert text",
        b = {":lua Abbrev('break')<CR>", "break"},
        l = {":lua Abbrev('lbreak')<CR>", "long break"},
        p = {":lua Abbrev('pdb')<CR>", "pdb"},
        t = {":lua Abbrev('this')<CR>", "test this"},
    },
    l = {name = "lsp",
        d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "definition"},
        h = {"<cmd>lua vim.lsp.buf.hover()<CR>", "hover"},
        l = {"<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", "list diagnostics"},
        r = {"<cmd>lua require('fzf-lua').lsp_references()<CR>", "references"},
        s = {"<cmd>lua vim.diagnostic.open_float()<CR>", "show line diagnostics"},
    },
    o = {name = "open",
        f = {"<cmd>lua require('fzf-lua').files({prompt = 'Files> ', actions = {['default'] = function(selected) open_fzf_files(selected) end}})<CR>", "files"},
        h = {"<cmd>lua require('fzf-lua').oldfiles()<CR>", "history"},
        s = {"<cmd>lua require('fzf-lua').fzf_exec('find ~/.local/share/nvim/sessions -type f', {prompt = 'Sessions> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('source ' .. selected[1]) end}})<CR>", "session"},
        t = {":FloatermNew<CR>", "terminal"},
    },
    t = {name = "test",
        c = {":lua NtCov()<CR>", "file coverage"},
        f = {":FloatermNew --wintype=floating --title=test-file --autoclose=0 nosetests -sv --nologcapture --with-id %:p<CR>", "file"},
        t = {":FloatermNew --wintype=floating --title=test-these --autoclose=0 nosetests -sv -a this --nologcapture %:p<CR>", "these"},
        x = {":FloatermNew --wintype=floating --title=test-file-stop --autoclose=0 nosetests -sv --nologcapture --with-id -x %:p<CR>", "stop at failure"},
    },
}, {prefix = "<leader>"})
wk.register({
    g = {name = "git",
        s = {":Gitsigns stage_hunk<CR><esc>", "stage selection"},
        u = {":Gitsigns undo_stage_hunk<CR><esc>", "undo stage selection"},
    }
}, {mode = "v", prefix = "<leader>"})

-- disable unused builtin plugins ------------------------------------------------------------------
local disabled_builtins = {'gzip', 'zip', 'zipPlugin', 'tar', 'tarPlugin', 'getscript',
                           'getscriptPlugin', 'vimball', 'vimballPlugin', '2html_plugin', 'logipat',
                           'rrhelper', 'spellfile_plugin', 'matchit'}
for _, plugin in pairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
end

-- status line -------------------------------------------------------------------------------------
function get_mode_color(mode)
    local mode_color = '%#OtherMode#'
    local mode_color_table = {
        n = '%#NormalMode#',
        i = '%#InsertMode#',
        R = '%#ReplaceMode#',
        v = '%#VisualMode#',
        V = '%#VisualMode#',
        [''] = '%#VisualMode#',
    }
    if mode_color_table[mode] then
        mode_color = mode_color_table[mode]
    end
    return mode_color
end

function get_readonly_char()
    local ro_char = ''
    if vim.bo.readonly or vim.bo.modifiable == false then ro_char = '' end
    return ro_char
end

function get_cwd()
    local dir = vim.api.nvim_call_function('getcwd', {})
    dir = vim.api.nvim_call_function('pathshorten', {dir})
    return dir
end

function scroll_bar()  -- from github.com/drzel/vim-line-no-indicator
    local chars = {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"}
    local current_line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
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

function gitsigns_status(key)
    local summary = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
    if summary[key] == nil then return '' end
    if summary[key] == '' then return '' end
    if summary[key] == 0 then return '' end
    local prefix = {head = ' ', added = '+', changed = '~', removed = '-'}
    return string.format(" %s%s ", prefix[key], summary[key])
end

function StatusLine()
    local status = ''
    status = status .. get_mode_color(vim.fn.mode()) .. [[ %-"]]
    status = status .. [[%#GitSignsAdd#%-{luaeval("gitsigns_status('head')")}]]
    status = status .. [[%#GitSignsAdd#%-{luaeval("gitsigns_status('added')")}]]
    status = status .. [[%#GitSignsChange#%-{luaeval("gitsigns_status('changed')")}]]
    status = status .. [[%#GitSignsDelete#%-{luaeval("gitsigns_status('removed')")}]]
    status = status .. '%#Directory# '
    status = status .. [[%-m %-{luaeval("get_readonly_char()")}]]
    status = status .. '%='
    status = status .. [[%-{luaeval("get_cwd()")} ]]
    status = status .. [[%#ScrollBar#%-{luaeval("scroll_bar()")}]]
    return status
end

vim.opt.statusline = '%!luaeval("StatusLine()")'
vim.opt.showtabline = 2

-- functions ---------------------------------------------------------------------------------------
function SaveSession()
    vim.ui.input({
        prompt = "Session name: ",
        default = '~/.local/share/nvim/sessions/',
        completion = 'file'
    },
    function(sessionName)
        if (sessionName ~= "" and sessionName ~= nil) then
            vim.fn.execute('mksession! ' .. vim.fn.fnameescape(sessionName))
        end
    end
    )
end

function Abbrev(_text)
    local abbrev_text_table = {
        sbreak = '# ' .. string.rep('-', 94),
        lbreak = '# ' .. string.rep('-', 98),
        pdb = 'breakpoint()',
        this = 'from nose.plugins.attrib import attr<CR>@attr("this")',
    }
    local cmd = abbrev_text_table[_text]
    vim.api.nvim_command(vim.api.nvim_replace_termcodes('normal! O' .. cmd .. '<ESC><CR>', true, false, true))
end

function NtCov()
    local prevPwd = vim.fn.getcwd()
    vim.cmd(":cd " .. vim.fn.expand('%:p:h'))
    local cov = vim.fn.split(vim.fn.substitute(vim.fn.split(vim.fn.expand('%:p'), "python/")[2], "/", ".", "g"), ".tests.")[1] .. "." .. vim.fn.substitute(vim.fn.substitute(vim.fn.expand('%'), "test_", "", ""), ".py", "", "")
    vim.cmd(":FloatermNew --wintype=floating --title=test-file-coverage --autoclose=0 nosetests --with-cov --cov=" .. cov .. " --cov-report=term-missing " .. vim.fn.expand('%') .. " --verbose")
    vim.cmd(":cd " .. prevPwd)
end

function git_show_diff(selected)
    local commit_hash = selected[1]:match("[^ ]+")
    local cmd = {"git", "show", commit_hash}
    local git_file_contents = vim.fn.systemlist(cmd)
    local file_name = string.gsub(vim.fn.expand("%:p"), "$", "[" .. commit_hash .. "]")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(buf, 0, 0, true, git_file_contents)
    vim.api.nvim_buf_set_name(buf, file_name)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'git')
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_win_set_buf(win, buf)
end

function open_fzf_files(selected)
    for _, e in ipairs(selected) do
        local file = require'fzf-lua'.path.entry_to_file(e)
        vim.cmd("e " .. file.path)
    end
end
