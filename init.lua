vim.g.python3_host_prog = vim.env.HOME .. "/.virtualenvs/nvim/bin/python3"
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "neovim/nvim-lspconfig",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("plugin.treesitter")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "lukas-reineke/cmp-rg",
        },
        event = "InsertEnter",
        config = function()
            require("plugin.nvim-cmp")
        end,
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("plugin.fzf-lua")
        end,
    },
    {
        "Shatur/neovim-ayu",
        lazy = false,
        priority = 1000,
        config = function()
            require("plugin.ayu")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("plugin.gitsigns")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("plugin.indent_blankline")
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("plugin.leap")
        end,
    },
    {
        "numToStr/FTerm.nvim",
        event = "VeryLazy",
        config = function()
            require("plugin.fterm")
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "echasnovski/mini.map",
        version = false,
        config = function()
            require("plugin.mini_map")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("plugin.which-key")
        end,
    },
})

-- load modules ------------------------------------------------------------------------------------
require "lsp"
require "settings"
require "autocmds"
require "statusline"
require "disable_plugins"
require "myfuncs"
