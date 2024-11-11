vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.autoindent = true


opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one:

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")
