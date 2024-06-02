local disabled_builtins = {'gzip', 'zip', 'tar', '2html_plugin', 'spellfile_plugin', 'matchit', 'man'}
for _, plugin in pairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
end

vim.g["loaded_ruby_provider"] = 0
vim.g["loaded_node_provider"] = 0
vim.g["loaded_perl_provider"] = 0
