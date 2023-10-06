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

function get_cwd(shorten)
    local dir = vim.api.nvim_call_function('getcwd', {})
    if shorten then
        dir = vim.api.nvim_call_function('pathshorten', {dir})
    end
    return dir
end

function gitsigns_status(key)
    local summary = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
    if summary[key] == nil then return '' end
    if summary[key] == '' then return '' end
    if summary[key] == 0 then return '' end
    local prefix = {head = ' ', added = '+', changed = '~', removed = '-'}
    return string.format(" %s%s ", prefix[key], summary[key])
end

function get_lsp_names()
    local clients = vim.lsp.get_active_clients()
    local lsps = {}
    for _, client in pairs(clients) do
        table.insert(lsps, client.name)
    end
    local lsp_names = ""
    if #lsps > 0 then
        lsp_names = "  " .. table.concat(lsps, ", ") .. " "
    end
    return lsp_names
end

function _get_current_function_name()
    local func_name = ""
    local clients = vim.lsp.get_active_clients()
    if next(clients) ~= nil then  -- effectively checks for an empty table in lua
        func_name = get_current_function_name()
        if func_name ~= nil and func_name ~= "" then
            if string.sub(func_name, 1, 1):match("%w") then
                func_name = " 󰊕  "  .. func_name .. " "
            else
                func_name = ""
            end
        elseif func_name ~= nil and func_name == "" then
            func_name = get_current_class_name()
            if func_name ~= "" then
                func_name = "  " .. func_name .. " "
            end
        end
    end
    return func_name
end

function status_line()
    local status = ''
    status = status .. get_mode_color(vim.fn.mode()) .. [[ %-"]]
    status = status .. [[%#GitSignsAdd#%-{luaeval("gitsigns_status('head')")}]]
    status = status .. [[%#GitSignsAdd#%-{luaeval("gitsigns_status('added')")}]]
    status = status .. [[%#GitSignsChange#%-{luaeval("gitsigns_status('changed')")}]]
    status = status .. [[%#GitSignsDelete#%-{luaeval("gitsigns_status('removed')")}]]
    status = status .. '%#Directory# '
    status = status .. '%='
    status = status .. [[%-{luaeval("get_cwd(false)")} ]]
    status = status .. [[%#WildMenu#%-{luaeval("get_lsp_names()")}]]
    return status
end

vim.opt.statusline = '%!luaeval("status_line()")'

-- winbar
function win_bar()
    local file_path = vim.fn.expand('%:~:.:h')
    local file_name = vim.fn.expand('%:t')
    local value = ' '

    file_path = file_path:gsub('^%.', '')
    file_path = file_path:gsub('^%/', '')

    if not (file_name == nil or file_name == '' or string.sub(file_path, 1, 5) == 'term:') then
        file_icon = ' '
        file_icon = '%#WinBarIcon#' .. file_icon .. '%*'
        local file_modified = ''
        if vim.bo.modified then
            file_modified = '%#WinBarModified#%*'
        end
        value = value .. file_icon .. file_name .. ' ' .. file_modified .. ' %-{luaeval("get_readonly_char()")}%#NonText#% %#CurSearch#%-{luaeval("_get_current_function_name()")}%#NonText#%'
    end
    return value
end

vim.opt.winbar = '%!luaeval("win_bar()")'
vim.opt.laststatus = 3
