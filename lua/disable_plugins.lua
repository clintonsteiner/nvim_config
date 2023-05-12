local disabled_builtins = {'gzip', 'zip', 'zipPlugin', 'tar', 'tarPlugin', 'getscript',
                           'getscriptPlugin', 'vimball', 'vimballPlugin', '2html_plugin', 'logipat',
                           'rrhelper', 'spellfile_plugin', 'matchit', 'tutor', 'man'}
for _, plugin in pairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
end
