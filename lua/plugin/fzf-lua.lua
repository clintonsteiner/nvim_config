require'fzf-lua'.setup {
    fzf_colors = {
        ['hl'] = {'sp', 'Underlined'},
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
vim.api.nvim_cmd({cmd = 'normal', args = {'FzfLua register_ui_select'}}, {})

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
