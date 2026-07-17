--------------------------------------------------
-- Leader
--------------------------------------------------

vim.g.mapleader = ","


--------------------------------------------------
-- Basic keymaps
--------------------------------------------------

local keymap = vim.keymap.set

-- Esc を 2 回押すと検索ハイライトを消す
keymap("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR><Esc>", { silent = true })

-- 折り返し時に表示行単位で移動する
keymap("n", "j", "gj", { silent = true })
keymap("n", "k", "gk", { silent = true })

-- cursor move
keymap({ "n", "v" }, "<C-n>", "20j")
keymap({ "n", "v" }, "<C-p>", "20k")

-- register
vim.fn.setreg("d", [[nf{mz%x`zvF\d`}]])

--------------------------------------------------
-- Insert blank lines
--------------------------------------------------

-- 上下に空行を挿入する operator 関数
-- count 指定で複数行対応
local function blank_above()
  local count = vim.v.count1
  local row = vim.api.nvim_win_get_cursor(0)[1]

  for _ = 1, count do
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
  end

  -- 挿入した先頭行へカーソル移動
  vim.api.nvim_win_set_cursor(0, { row, 0 })
end

local function blank_below()
  local count = vim.v.count1
  local row = vim.api.nvim_win_get_cursor(0)[1]

  for _ = 1, count do
    vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
  end
end

keymap("n", "<Space>O", blank_above, { silent = true })
keymap("n", "<Space>o", blank_below, { silent = true })


--------------------------------------------------
-- User commands
--------------------------------------------------

-- 画面を再描画 (:R)
vim.api.nvim_create_user_command("R", "redraw!", {})


--------------------------------------------------
-- zsh execution
--------------------------------------------------

-- 現在の zsh ファイルを保存して下部に terminal で実行する
local sh_run_group = vim.api.nvim_create_augroup("sh_run_cmd", {
  clear = true,
})

vim.api.nvim_create_autocmd("FileType", {
  group = sh_run_group,
  pattern = "zsh",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "Run", function(opts)
      vim.cmd("update")  -- ファイル保存

      local file = vim.fn.shellescape(vim.fn.expand("%:p"))
      local args = table.concat(opts.fargs, " ")
      local cmd = file .. (#args > 0 and (" " .. args) or "")

      -- 下部に高さ5行のターミナルを開く
      vim.cmd("botright 5split")
      vim.cmd("terminal " .. cmd)
    end, {
      nargs = "*",
    })

    -- :run を :Run に展開
    vim.cmd("cnoreabbrev <buffer> run Run")
  end,
})


--------------------------------------------------
-- Insert Mode
--------------------------------------------------

-- `Shift+Tab` でインデントを一段削除
keymap("i", "<S-Tab>", "<C-d>", { noremap = true })
