--------------------------------------------------
-- lazy.nvim bootstrap
--------------------------------------------------

-- lazy.nvim をインストール（未インストール時のみ）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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


--------------------------------------------------
-- Plugins
--------------------------------------------------

require("lazy").setup({

  ------------------------------------------------
  -- Color scheme: iceberg
  ------------------------------------------------

  {
    "cocopon/iceberg.vim",
    lazy = false,        -- 起動時に読み込む
    priority = 1000,     -- 他の plugin より先に適用
    config = function()
      -- colorscheme の適用（失敗時は default）
      local ok, _ = pcall(vim.cmd, "colorscheme iceberg")
      if not ok then
        vim.cmd("colorscheme default")
      end
    end,
  },


  ------------------------------------------------
  -- Clipboard: OSC52 (vim-oscyank)
  ------------------------------------------------

  {
    "ojroques/vim-oscyank",
    config = function()
      -- 成功メッセージを表示しない
      vim.g.oscyank_silent = 1

      -- keymap（operator / visual）
      local keymap = vim.keymap.set
      keymap("n", "<leader>c", "<Plug>OSCYankOperator")
      keymap("n", "<leader>cc", "<leader>c_")
      keymap("v", "<leader>c", "<Plug>OSCYankVisual")

      -- yank 時に自動で OSC52 転送
      if vim.fn.exists("*OSCYankRegister") == 1 then
        local group = vim.api.nvim_create_augroup("osc_auto_yank", {
          clear = true,
        })

        vim.api.nvim_create_autocmd("TextYankPost", {
          group = group,
          callback = function()
            local ev = vim.v.event

            -- yank 操作かつ対象レジスタの場合のみ実行
            if ev.operator == "y"
              and vim.tbl_contains({ "", "+", "*" }, ev.regname)
            then
              local reg = (ev.regname == "") and '"' or ev.regname
              vim.fn.OSCYankRegister(reg)
            end
          end,
        })
      end
    end,
  },


  ------------------------------------------------
  -- Syntax / filetype support
  ------------------------------------------------

  {
    "sheerun/vim-polyglot",
  },

}, {
  lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
})
