function abbrev(_text)
    local abbrev_text_table = {
        sbreak = '# ' .. string.rep('-', 94),
        lbreak = '# ' .. string.rep('-', 98),
        pdb = 'breakpoint()',
        this = 'import pytest<CR>@pytest.mark.this',
    }
    local cmd = abbrev_text_table[_text]
    vim.api.nvim_command(vim.api.nvim_replace_termcodes('normal! O' .. cmd .. '<ESC><CR>', true, false, true))
end

function get_pytest_cov_cmd()
    local cov_cmd = vim.fn.split(vim.fn.substitute(vim.fn.split(vim.fn.expand('%:p:h'), "python/")[2], "/", ".", "g"), ".tests")[1] .. "." .. vim.fun.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand('%'), "test_", "", ""), ".py", "", ""), "tests/", "", "g")
    return cov_cmd
end

function save_session()
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

function fzf_git_blame(opts)
    local fzf_lua = require'fzf-lua'
    opts = fzf_lua.defaults.git.files
    opts.previewer = false
    opts.prompt = "Blame> "
    opts.cmd = "for i in " .. vim.api.nvim_buf_get_name(0) .. " ; do git blame --color-by-age ${i} ; done"
    opts.cwd = vim.fn.expand('%:p:h')
    fzf_lua.fzf_exec(opts.cmd, opts)
end

function toggle_text_wrap()
    local current_setting = vim.o.textwidth
    if current_setting == 0 then
        current_setting = 100
        print("text wrap on")
    else
        current_setting = 0
        print("text wrap off")
    end
    vim.o.textwidth = current_setting
end

function toggle_diagnostics()
    local current_setting = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({virtual_text = not current_setting, signs = not current_setting, underline = not current_setting})
end

function get_pytest_single_test_arg()
    local pytest_arg = vim.fn.expand('%:p') .. '::' .. get_current_class_name() .. '::' .. get_current_function_name()
    return pytest_arg
end

function get_last_test_name()
    vim.cmd("py import os\npy import json")
    vim.cmd("py root_path = os.environ['MY_ROOT_PATH_CHANGE_ME']")
    vim.cmd("py pytest_config_path = os.path.join(f'{root_path}/change/me/.pytest_cache/v/cache/nodeids')")
    vim.cmd("py fp = open(pytest_config_path)")
    vim.cmd("py last_test = json.load(fp)")
    vim.cmd("py fp.close()")
    vim.cmd("py last_test = os.path.join(f'{root_path}/change/me/{last_test[0]}')")
    local last_test_name = vim.fn.pyeval("last_test")
    return last_test_name
end
