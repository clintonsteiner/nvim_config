local actions = require'fzf-lua.actions'
require'fzf-lua'.setup {
    actions = {
        files = {
            -- open multiple-selected files in separate buffers vs. quickfix
            ["default"] = actions.file_edit,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"] = actions.file_sel_to_qf,
        },
    },
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
    nbsp = '\xc2\xa0',
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
