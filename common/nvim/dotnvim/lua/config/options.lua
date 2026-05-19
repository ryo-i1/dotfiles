--------------------------------------------------
-- Encoding
--------------------------------------------------

vim.opt.encoding = "utf-8"      -- Neovim 内部で使う文字コード
vim.opt.fileencoding = "utf-8"  -- 保存時の文字コード


--------------------------------------------------
-- UI: basic appearance
--------------------------------------------------

vim.opt.title = true            -- ターミナルやウィンドウのタイトルを更新
vim.opt.number = true           -- 絶対行番号を表示
vim.opt.relativenumber = true   -- 相対行番号を表示
vim.opt.signcolumn = "yes:1"    -- 行番号左にsign列を確保
vim.opt.cursorline = true       -- カーソル行をハイライト
vim.opt.scrolloff = 3           -- カーソル上下に表示行を確保

-- 不可視文字を表示する
vim.opt.list = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  extends = "»",
  precedes = "«",
  nbsp = "%",
}

vim.opt.background = "dark"
vim.opt.termguicolors = true    -- true color を有効化

vim.opt.showmatch = true        -- 対応する括弧を短時間ハイライト
vim.opt.matchtime = 1           -- 括弧ハイライトの表示時間

vim.opt.display = "lastline"    -- 長い行でもできるだけ末尾まで表示
vim.opt.foldenable = false      -- 折りたたみを無効化

vim.opt.visualbell = true       -- 音の代わりに画面点滅を使う
vim.opt.errorbells = false      -- エラー音を無効化

-- 背景を透明にする
local function transparent_bg()
  vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NormalNC guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE
    highlight SignColumn guibg=NONE
    highlight VertSplit guibg=NONE
  ]])
end

transparent_bg()
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = transparent_bg,
})

--vim.opt.colorcolumn = "81"      -- 垂直補助線を引く
local function setup_overlength()
  vim.api.nvim_set_hl(0, "OverLength", {
      underdotted = true,
      sp = "#89b8ff",
  })

  -- 重複登録を避ける
  for _, m in ipairs(vim.fn.getmatches()) do
    if m.group == "OverLength" then
      vim.fn.matchdelete(m.id)
    end
  end

  vim.fn.matchadd("OverLength", "\\%>80v.", 200)  -- 81桁目以降を強調
end

vim.api.nvim_create_autocmd({
    "VimEnter",
    "BufEnter",
    "WinEnter",
    "ColorScheme",
}, {
  callback = setup_overlength,
})


--------------------------------------------------
-- UI: status / command line
--------------------------------------------------

vim.opt.laststatus = 2          -- ステータス行を常に表示
vim.opt.cmdheight = 2           -- メッセージ表示欄を 2 行確保
vim.opt.wildmenu = true         -- コマンドライン補完候補をメニュー表示
vim.opt.wildmode = "list:longest"
vim.opt.showcmd = true          -- 入力中のコマンドを右下に表示


--------------------------------------------------
-- Window
--------------------------------------------------

vim.opt.splitright = true       -- 縦分割を右側に開く
vim.opt.splitbelow = true       -- 横分割を下側に開く


--------------------------------------------------
-- Cursor movement
--------------------------------------------------

-- visual block 時の列揃えと，行末 1 文字先への移動を許可する
vim.opt.virtualedit = { "block", "onemore" }

vim.opt.whichwrap = "b,s,h,l,<,>,[,],~"  -- 行をまたぐカーソル移動を許可
vim.opt.iskeyword = "@,48-57,192-255,#"  -- 単語として扱う文字を指定


--------------------------------------------------
-- Search
--------------------------------------------------

vim.opt.ignorecase = true       -- 検索時は大文字・小文字を区別しない
vim.opt.smartcase = true        -- 検索語に大文字が含まれる場合は区別する
vim.opt.incsearch = true        -- 入力中に検索結果へ移動する
vim.opt.hlsearch = true         -- 検索結果をハイライトする
vim.opt.wrapscan = true         -- 末尾まで検索したら先頭から再検索する


--------------------------------------------------
-- Indent / tab
--------------------------------------------------

vim.opt.cinoptions:append(":0") -- C インデントの一部を調整
vim.opt.expandtab = true        -- Tab 入力をスペースに展開
vim.opt.tabstop = 2             -- タブ文字の表示幅
vim.opt.softtabstop = 2         -- Tab / BS 操作時の見かけ上の幅
vim.opt.shiftwidth = 2          -- 自動インデント幅
vim.opt.autoindent = true       -- 前行のインデントを引き継ぐ

-- '#' で始まる行のインデントを崩さない
vim.opt.cinkeys:remove("0#")
vim.opt.indentkeys:remove("0#")

-- markdown で indent を無効化
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
--      vim.opt_local.formatoptions:remove({ "o", "r" })
      vim.opt_local.indentexpr = ""
    end,
})


--------------------------------------------------
-- Mouse
--------------------------------------------------

vim.opt.mouse = "a"             -- 全てのモードでマウスを有効化


--------------------------------------------------
-- General behaviour
--------------------------------------------------

vim.opt.ambiwidth = "double"    -- 全角文字を 2 桁幅として扱う
vim.opt.nrformats = ""          -- 数値を常に 10 進数として扱う
vim.opt.clipboard = "unnamed"   -- レジスタと OS のクリップボードを同期

vim.opt.history = 10000         -- コマンドライン履歴の保存件数
vim.opt.swapfile = false        -- swap file を作成しない
vim.opt.backup = false          -- backup file を作成しない
