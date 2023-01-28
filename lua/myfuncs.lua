function abbrev(_text)
    local abbrev_text_table = {
        sbreak = '# ' .. string.rep('-', 94),
        lbreak = '# ' .. string.rep('-', 98),
        pdb = 'breakpoint()',
        this = 'from nose.plugins.attrib import attr<CR>@attr("this")',
    }
    local cmd = abbrev_text_table[_text]
    vim.api.nvim_command(vim.api.nvim_replace_termcodes('normal! O' .. cmd .. '<ESC><CR>', true, false, true))
end

function nt_cov()
    local prevPwd = vim.fn.getcwd()
    vim.cmd(":cd " .. vim.fn.expand('%:p:h'))
    local cov = vim.fn.split(vim.fn.substitute(vim.fn.split(vim.fn.expand('%:p'), "python/")[2], "/", ".", "g"), ".tests.")[1] .. "." .. vim.fn.substitute(vim.fn.substitute(vim.fn.expand('%'), "test_", "", ""), ".py", "", "")
    vim.cmd(":FloatermNew --wintype=floating --title=test-file-coverage --autoclose=0 nosetests --with-cov --cov=" .. cov .. " --cov-report=term-missing " .. vim.fn.expand('%') .. " --verbose")
    vim.cmd(":cd " .. prevPwd)
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
