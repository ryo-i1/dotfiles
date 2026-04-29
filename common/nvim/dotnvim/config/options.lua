-- Encoding
vim.opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- UI: basic appearance
vim.opt.title = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.list = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  extends = "»",
  precedes = "«",
  nbsp = "%",
}

vim.cmd("syntax on")
vim.opt.background = "dark"

vim.opt.showmatch = true
vim.opt.matchtime = 1

vim.opt.display = "lastline"
vim.opt.foldenable = false

vim.opt.visualbell = true
vim.opt.errorbells = false
pcall(vim.cmd, "set t_vb=")

-- UI: status / command line
vim.opt.laststatus = 2
vim.opt.cmdheight = 2
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.showcmd = true

-- Cursor movement
vim.opt.virtualedit = { "block", "onemore" }
vim.opt.whichwrap = "b,s,h,l,<,>,[,],~"
vim.opt.iskeyword = "@,48-57,192-255,#"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true

-- Indent / tab
vim.opt.cinoptions:append(":0")
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

vim.opt.cinkeys:remove("0#")
vim.opt.indentkeys:remove("0#")

vim.api.nvim_create_augroup("fileTypeIndent", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "fileTypeIndent",
  pattern = "*.sh",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "fileTypeIndent",
  pattern = "*.c",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Mouse
vim.opt.mouse = "a"

-- General behaviour
vim.opt.ambiwidth = "double"
vim.opt.nrformats = ""

vim.opt.clipboard = "unnamed"

vim.opt.history = 10000
vim.opt.swapfile = false
vim.opt.backup = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})
