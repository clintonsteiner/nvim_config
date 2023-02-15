local colors = require('ayu.colors')
local use_mirage = true
colors.generate(use_mirage)
require('ayu').setup({
    mirage = use_mirage,
    overrides = {
        LineNr = {fg = colors.comment},
        WinBar = {fg = colors.keyword, bg = colors.selection_inactive},
        WinBarIcon = {fg = colors.tag, bg = colors.selection_inactive},
        WinBarDirSep = {fg = colors.accent, bg = colors.selection_inactive},
        WinBarModified = {fg = colors.string, bg = colors.selection_inactive},
        NormalMode = {fg = colors.string, bg = colors.bg, reverse = true, bold = true},
        InsertMode = {fg = colors.tag, bg = colors.bg, reverse = true, bold = true},
        VisualMode = {fg = colors.keyword, bg = colors.bg, reverse = true, bold = true},
        ReplaceMode = {fg = colors.markup, bg = colors.bg, reverse = true, bold = true},
        OtherMode = {fg = colors.constant, bg = colors.bg, reverse = true, bold = true},
        GitSignsChangeDelete = {fg = colors.constant},
        ['@variable.builtin'] = {fg = colors.constant, italic = true},
        LeapBackdrop = {fg = colors.comment},
    }
})
require('ayu').colorscheme()
