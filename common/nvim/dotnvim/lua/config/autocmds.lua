--------------------------------------------------
-- Indent
--------------------------------------------------

local filetype_indent_group = vim.api.nvim_create_augroup("fileTypeIndent", {
  clear = true,
})

-- shell script, zsh, C ではインデント幅を 4 にする
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = filetype_indent_group,
  pattern = { "*.sh", "*.zsh", "*.c", "*.h" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})


--------------------------------------------------
-- Format options
--------------------------------------------------

-- コメント行で改行しても，次行を自動コメント化しない
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})


--------------------------------------------------
-- Quit behavior
--------------------------------------------------

-- help / quickfix などの特殊ウィンドウだけが残る場合は自動で閉じる
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].buftype == "" then
          return
        end
      end
    end

    vim.cmd.only({ bang = true })
  end,
})
