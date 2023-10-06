local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'python', highlight = {enable = true}, indent = {enable = true}}

function get_current_function_name()
    if vim.bo.filetype ~= "python" then return "" end
    local current_node = vim.treesitter.get_node()
    if not current_node then return "" end

    local expr = current_node
    while expr do
        if expr:type() == 'function_definition' then
            break
        end
        expr = expr:parent()
    end
    if not expr then return "" end

    return (vim.treesitter.get_node_text(expr:child(1), 0))
end

function get_current_class_name()
    if vim.bo.filetype ~= "python" then return "" end
    local current_node = vim.treesitter.get_node()
    if not current_node then return "" end

    local expr = current_node
    while expr do
        if expr:type() == 'class_definition' then
            break
        end
        expr = expr:parent()
    end
    if not expr then return "" end

    return (vim.treesitter.get_node_text(expr:child(1), 0))
end
