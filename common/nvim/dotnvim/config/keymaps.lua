vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Esc を 2 回押すと検索ハイライトを消す
keymap("n", "<Esc><Esc>", ":nohlsearch<CR><ESC>", { silent = true })

-- 折り返し時に表示行単位で移動
keymap("n", "j", "gj", { silent = true })
keymap("n", "k", "gk", { silent = true })

-- Insert blank lines
vim.cmd([[
function! s:blank_above(type = '') abort
  if a:type == ''
    set operatorfunc=function('s:blank_above')
    return 'g@ '
  endif

  put! =repeat(nr2char(10), v:count1)
  normal! '[
endfunction

function! s:blank_below(type = '') abort
  if a:type == ''
    set operatorfunc=function('s:blank_below')
    return 'g@ '
  endif

  put =repeat(nr2char(10), v:count1)
endfunction

nnoremap <expr> <Space>o <SID>blank_below()
nnoremap <expr> <Space>O <SID>blank_above()
]])

-- 画面を再描画 (:R)
vim.api.nvim_create_user_command("R", "redraw!", {})

-- zsh execution
vim.api.nvim_create_augroup("sh_run_cmd", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "sh_run_cmd",
  pattern = "zsh",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "Run", function(opts)
      vim.cmd("update")

      local file = vim.fn.shellescape(vim.fn.expand("%:p"))
      local args = table.concat(opts.fargs, " ")
      local cmd = file .. (#args > 0 and (" " .. args) or "")

      vim.cmd("botright 5split")
      vim.cmd("terminal " .. cmd)
    end, {
      nargs = "*",
    })

    vim.cmd("cnoreabbrev <buffer> run Run")
  end,
})
