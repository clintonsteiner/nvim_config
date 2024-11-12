#!/bin/bash

if [ ! "$#" -gt 0 ] ; then
    ~/apps/neovim/nvim-macos-arm64/bin/nvim
else
    ~/apps/neovim/nvim-macos-arm64/bin/nvim "$@"
fi
