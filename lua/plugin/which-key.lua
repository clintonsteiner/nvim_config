local wk = require("which-key")
local fzf = require("plugin.fzf-lua")

wk.add({
    { "<S-Tab>", ":bn<CR>", desc = "next buffer" },
    { "<Tab>", "<C-^>", desc = "last buffer" },

    { "<leader> ", "<cmd>lua require('fzf-lua').buffers()<CR>", desc = "buffers" },
    { "<leader>/", "<cmd>lua require('fzf-lua').blines({start = 'cursor', fzf_cli_args = '--with-nth=3..'})<CR>", desc = "blines" },
    { "<leader>:", ":source ~/.local/share/nvim/sessions/init<CR>", desc = "open init" },
    { "<leader>?", "<cmd>lua require('fzf-lua').lines({fzf_cli_args = '--with-nth 2..'})<CR>", desc = "lines" },
    { "<leader>f", "<cmd>lua require('fzf-lua').builtin()<CR>", desc = "fzf builtins" },
    { "<leader>h", "<cmd>lua require('fzf-lua').help_tags()<CR>", desc = "help" },
    { "<leader>s", ":lua save_session()<CR>", desc = "save session" },
    { "<leader>w", ":w<CR>", desc = "save" },

    { "<leader>c", group = "change dir" },
    { "<leader>cc", ":cd %:p:h<CR>", desc = "change dir cwd" },
    { "<leader>cd", "<cmd>lua require('fzf-lua').fzf_exec([[(echo '..' ; echo '-' ; echo '~' ; find . -type d ! -path \"*.git*\" -follow 2>/dev/null)]], {prompt = 'Cd> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('cd ' .. selected[1]) end}})<CR>", desc = "change dir" },
        -- use if switch to fd over find:
        -- { "<leader>cd", "<cmd>lua require('fzf-lua').fzf_exec([[(echo '..' ; echo '-' ; echo '~' ; fd --type=d --follow --hidden --exclude=.git 2>/dev/null)]], {prompt = 'Cd> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('cd ' .. selected[1]) end}})<CR>", desc = "change dir" },

    { "<leader>g", group = "git" },
    { "<leader>ga", "<cmd>lua require('FTerm').scratch({cmd = {'git', 'add', '-i'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "stage interactively" },
    { "<leader>gb", "<cmd>Gitsigns blame<CR>", desc = "blame" },
    { "<leader>gc", ":cd %:p:h<CR><cmd>lua require('FTerm').scratch({cmd = {'git', 'commit'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "commit" },
    { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "diff" },
    { "<leader>gg", "<cmd>lua require('fzf-lua').git_status()<CR>", desc = "status" },
    { "<leader>gi", "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", desc = "blame inline" },
    { "<leader>gj", "<cmd>lua require('gitsigns').nav_hunk('next')<CR>", desc = "next hunk" },
    { "<leader>gk", "<cmd>lua require('gitsigns').nav_hunk('prev')<CR>", desc = "prev hunk" },
    { "<leader>gl", "<cmd>lua require('fzf-lua').git_bcommits({cmd = [[git log --color=always --pretty=format:%C\\(auto\\)%h\\ %s\\ %C\\(green\\)%cs\\ %an]], actions = {['default'] = function(selected) git_show_diff(selected) end}, winopts = {preview = {hidden = 'hidden'}}})<CR>", desc = "log" },
    { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "preview hunk" },
    { "<leader>gr", "<cmd>lua require('FTerm').scratch({cmd = {'git', 'reset', '-p'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "unstage" },
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "stage hunk" },
    { "<leader>gt", "<cmd>lua require('fzf-lua').git_stash()<CR>", desc = "stash list" },
    { "<leader>gu", "<cmd>Gitsigns reset_hunk<CR>", desc = "undo hunk" },

    { "<leader>i", group = "insert text" },
    { "<leader>ib", ":lua abbrev('sbreak')<CR>", desc = "break" },
    { "<leader>il", ":lua abbrev('lbreak')<CR>", desc = "long break" },
    { "<leader>ip", ":lua abbrev('pdb')<CR>", desc = "pdb" },
    { "<leader>it", ":lua abbrev('this')<CR>", desc = "test this" },

    { "<leader>l", group = "lsp" },
    { "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "code actions" },
    { "<leader>ld", "<cmd>lua require('fzf-lua').lsp_definitions({jump_to_single_result = true})<CR>", desc = "definition" },
    { "<leader>lf", "<cmd>lua darker()<CR>", desc = "apply darker" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover" },
    { "<leader>ll", "<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", desc = "list diagnostics" },
    { "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename" },
    { "<leader>lr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", desc = "references" },
    { "<leader>ls", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "show line diagnostics" },

    { "<leader>o", group = "open" },
    { "<leader>of", "<cmd>lua require('fzf-lua').files({cwd_prompt = false, prompt = 'Files> ', git_icons = false})<CR>", desc = "files" },
    { "<leader>oh", "<cmd>lua require('fzf-lua').oldfiles()<CR>", desc = "history" },
    { "<leader>os", "<cmd>lua require('fzf-lua').fzf_exec('find ~/.local/share/nvim/sessions -type f ! -path \"*.git*\"', {prompt = 'Sessions> ', previewer = false, actions = {['default'] = function(selected) vim.api.nvim_command('source ' .. selected[1]) end}})<CR>", desc = "session" },
    { "<leader>ot", "<cmd>lua require('FTerm').open()<CR>", desc = "terminal" },

    { "<leader>p", group = "pytest" },
    { "<leader>pc", "<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', '--cov', get_pytest_cov_cmd(), vim.fn.expand('%:p'), '--cov-report', 'term-missing'}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "file coverage" },
    { "<leader>pf", "<cmd>lua require('FTerm').scratch({cmd = {'nosetests', '-sv', '--nologcapture', '--with-id', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "(nose) file" },
    { "<leader>pl", "<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', get_last_test_name()}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "last-run test" },
    { "<leader>pt", "<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', '-m', 'this', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "these" },
    { "<leader>px", "<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', '--pdb', '-x', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "stop at failure" },
    { "<leader>py", "<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', vim.fn.expand('%:p')}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "file" },
    { "<leader>pz", "<cmd>lua require('FTerm').scratch({cmd = {'pytest', '-sv', '--disable-pytest-warnings', get_pytest_single_test_arg()}, hl = 'Normal,FloatBorder:FzfLuaBorder'})<CR>", desc = "under cursor" },

    { "<leader>r", group = "ripgrep" },
    { "<leader>rg", "<cmd>lua require('fzf-lua').live_grep({git_icons = false})<CR>", desc = "rg" },
    { "<leader>rl", "<cmd>lua require('fzf-lua').grep_last()<CR>", desc = "rg last" },
    { "<leader>rr", "<cmd>lua require('fzf-lua').grep_cword({multiline = 2})<CR>", desc = "rg word under cursor" },

    { "<leader>t", group = "toggles" },
    { "<leader>td", "<cmd>lua toggle_diagnostics()<CR>", desc = "diagnostics" },
    { "<leader>ti", ":IBLToggle<CR>", desc = "indents" },
    { "<leader>tm", "<cmd>lua require('mini.map').toggle()<CR>", desc = "mini map" },
    { "<leader>tw", "<cmd>lua toggle_text_wrap()<CR>", desc = "text wrap" },

    {
        mode = { "v" },
        { "<leader>g", group = "git" },
        { "<leader>gs", ":Gitsigns stage_hunk<CR><esc>", desc = "stage selection" },
        { "<leader>gu", ":Gitsigns undo_stage_hunk<CR><esc>", desc = "undo stage selection" },
    },
})
