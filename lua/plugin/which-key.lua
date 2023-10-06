vim.g.mapleader = ' '
local wk = require("which-key")
local fzf = require("plugin.fzf-lua")

wk.register({
    ['<CR>'] = {"<cmd>noh<CR><CR>", "remove highlights"},
    ['<Tab>'] = {"<C-^>", "last buffer"},
    ['<S-Tab>'] = {":bn<CR>", "next buffer"},
})
wk.register({
    ['/'] = {"<cmd>lua require('fzf-lua').blines()<CR>", "blines"},
    ['?'] = {"<cmd>lua require('fzf-lua').lines({fzf_cli_args = '--with-nth 2..'})<CR>", "lines"},
    [':'] = {":source ~/.local/share/nvim/sessions/init<CR>", "open init"},
    [' '] = {"<cmd>lua require('fzf-lua').buffers()<CR>", "buffers"},
    f = {"<cmd>lua require('fzf-lua').builtin()<CR>", "fzf builtins"},
    h = {"<cmd>lua require('fzf-lua').help_tags()<CR>", "help"},
    s = {":lua save_session()<CR>", "save session"},
    w = {":w<CR>", "save"},
    c = {name = "change dir",
        c = {":cd %:p:h<CR>", "change dir cwd"},
        d = {"<cmd>lua require('fzf-lua').fzf_exec([[(echo '..' ; echo '-' ; echo '~' ; find . -type d ! -path \"*.git*\" -follow 2>/dev/null)]], {prompt = 'Cd> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('cd ' .. selected[1]) end}})<CR>", "change dir"},
    },
    g = {name = "git",
        a = {"<cmd>lua require('FTerm').scratch({cmd = {'git', 'add', '-i'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "stage interactively"},
        b = {"<cmd>lua fzf_git_blame()<CR>", "blame"},
        c = {":cd %:p:h<CR><cmd>lua require('FTerm').scratch({cmd = {'git', 'commit'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "commit"},
        d = {"<cmd>Gitsigns diffthis<CR>", "diff"},
        g = {"<cmd>lua require('fzf-lua').git_status()<CR>", "status"},
        i = {"<cmd>lua require('gitsigns').blame_line{full=true}<CR>", "blame inline"},
        j = {"<cmd>Gitsigns next_hunk<CR>", "next hunk"},
        k = {"<cmd>Gitsigns prev_hunk<CR>", "prev hunk"},
        l = {"<cmd>lua require('fzf-lua').git_bcommits({cmd = [[git log --color=always --pretty=format:%C\\(auto\\)%h\\ %s\\ %C\\(green\\)%cs\\ %an]], actions = {['default'] = function(selected) git_show_diff(selected) end}})<CR>", "log"},
        p = {"<cmd>Gitsigns preview_hunk_inline<CR>", "preview hunk"},
        r = {"<cmd>lua require('FTerm').scratch({cmd = {'git', 'reset', '-p'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "unstage"},
        s = {"<cmd>Gitsigns stage_hunk<CR>", "stage hunk"},
        t = {"<cmd>lua require('fzf-lua').git_stash()<CR>", "stash list"},
        u = {"<cmd>Gitsigns reset_hunk<CR>", "undo hunk"},
    },
    i = {name = "insert text",
        b = {":lua abbrev('sbreak')<CR>", "break"},
        l = {":lua abbrev('lbreak')<CR>", "long break"},
        p = {":lua abbrev('pdb')<CR>", "pdb"},
        t = {":lua abbrev('this')<CR>", "test this"},
    },
    l = {name = "lsp",
        c = {"<cmd>lua vim.lsp.buf.code_action()<CR>", "code actions"},
        d = {"<cmd>lua require('fzf-lua').lsp_definitions({jump_to_single_result = true})<CR>", "definition"},
        h = {"<cmd>lua vim.lsp.buf.hover()<CR>", "hover"},
        l = {"<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", "list diagnostics"},
        r = {"<cmd>lua require('fzf-lua').lsp_references()<CR>", "references"},
        s = {"<cmd>lua vim.diagnostic.open_float()<CR>", "show line diagnostics"},
    },
    o = {name = "open",
        f = {"<cmd>lua require('fzf-lua').files({cwd_prompt = false, prompt = 'Files> '})<CR>", "files"},
        h = {"<cmd>lua require('fzf-lua').oldfiles()<CR>", "history"},
        s = {"<cmd>lua require('fzf-lua').fzf_exec('find ~/.local/share/nvim/sessions -type f ! -path \"*.git*\"', {prompt = 'Sessions> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('source ' .. selected[1]) end}})<CR>", "session"},
        t = {"<cmd>lua require('FTerm').open()<CR>", "terminal"},
    },
    p = {name = "pytest",
        c = {"<cmd>lua require('FTerm').scratch({cmd = nt_cov(), hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "(nose) file coverage"},
        f = {"<cmd>lua require('FTerm').scratch({cmd = {'nosetests', '-sv', '--nologcapture', '--with-id', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "(nose) file"},
        t = {"<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', '-m', 'this', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "these"},
        x = {"<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', '--pdb', '-x', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "stop at failure"},
        y = {"<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "file"},
        z = {"<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', get_pytest_single_test_arg()}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", "under cursor"},
    },
    r = {name = "ripgrep",
        g = {"<cmd>lua require('fzf-lua').live_grep()<CR>", "rg"},
        l = {"<cmd>lua require('fzf-lua').grep_last()<CR>", "rg last"},
        r = {"<cmd>lua require('fzf-lua').grep_cword()<CR>", "rg word under cursor"},
    },
    t = {name = "toggles",
        d = {"<cmd>lua toggle_diagnostics()<CR>", "diagnostics"},
        i = {":IndentBlanklineToggle<CR>", "indents"},
        m = {"<cmd>lua require('mini.map').toggle()<CR>", "mini map"},
        w = {"<cmd>lua toggle_text_wrap()<CR>", "text wrap"},
    },
}, {prefix = "<leader>"})
wk.register({
    g = {name = "git",
        s = {":Gitsigns stage_hunk<CR><esc>", "stage selection"},
        u = {":Gitsigns undo_stage_hunk<CR><esc>", "undo stage selection"},
    }
}, {mode = "v", prefix = "<leader>"})
