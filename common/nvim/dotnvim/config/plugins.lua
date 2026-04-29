-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[
        try
          colorscheme iceberg
        catch
          colorscheme default
        endtry
      ]])
    end,
  },

  {
    "ojroques/vim-oscyank",
    config = function()
      vim.g.oscyank_silent = 1

      vim.keymap.set("n", "<leader>c", "<Plug>OSCYankOperator")
      vim.keymap.set("n", "<leader>cc", "<leader>c_")
      vim.keymap.set("v", "<leader>c", "<Plug>OSCYankVisual")

      vim.cmd([[
        if exists('*OSCYankRegister')
          augroup osc_auto_yank
            autocmd!
            autocmd TextYankPost *
              \ if v:event.operator is# 'y'
              \    && index(['', '+', '*'], v:event.regname) >= 0
              \ |     let l:reg = v:event.regname ==# '' ? '"' : v:event.regname
              \ |     call OSCYankRegister(l:reg)
              \ | endif
          augroup END
        endif
      ]])
    end,
  },

  {
    "sheerun/vim-polyglot",
  },
})
