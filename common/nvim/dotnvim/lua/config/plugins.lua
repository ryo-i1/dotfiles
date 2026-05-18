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
-- Functions
--------------------------------------------------

-- path formatter
--
-- HOME は "~" 表記
-- 最後の 2 階層以外は 1 文字に短縮
local function format_path(path)

  -- del prefix
  path = path:gsub("^oil://", "")

  -- start with "~"
  local home = vim.fn.expand("~")
  if vim.startswith(path, home) then
    path = "~" .. path:sub(#home + 1)
  end

  -- split path with "/"
  local parts = vim.split(path, "/", { plain = true })

  local shortened = {}
  for i, part in ipairs(parts) do

    -- root ("/")
    if part == "" then
      table.insert(shortened, "")

    -- HOME ("~")
    elseif part == "~" then
      table.insert(shortened, "~")

    -- last directories
    elseif i > #parts - 3 then
      table.insert(shortened, part)

    -- 途中階層
    else
      table.insert(shortened, part:sub(1, 1))
    end
  end

  -- "/" で結合
  return table.concat(shortened, "/")
end

-- lualine path
local function lualine_path()
  local path = vim.api.nvim_buf_get_name(0)
  return format_path(path)
end


-- oil close
--
-- close oil window normally.
-- if there are no non-oil windows, quit Neovim itself.
local function oil_close_or_quit()

  -- all windows in current tabpage
  local wins = vim.api.nvim_tabpage_list_wins(0)

  -- windows except oil
  local non_oil_wins = vim.tbl_filter(function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      return vim.bo[buf].filetype ~= "oil"
  end, wins)

  -- only oil is open
  if #non_oil_wins == 0 then
    vim.cmd("quit")

  -- close only oil window
  else
    require("oil.actions").close.callback()
  end
end


--------------------------------------------------
-- Plugins
--------------------------------------------------

require("lazy").setup({

  -- Color scheme: iceberg
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


  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      options = {
        theme = "iceberg",
        globalstatus = true,
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { lualine_path },

        lualine_x = { "diagnostics" },
        lualine_y = { "encoding", "filetype" },
        lualine_z = { "location" },
      },
    },
  },


  -- file explorer
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      default_file_explorer = true,
      delete_to_trash = true,

      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      view_options = {
        show_hidden = true,
      },

      keymaps = {
        ["q"] = oil_close_or_quit,
      },
    },

    keys = {
      { "<leader>e", "<CMD>Oil<CR>", desc = "Open file explorer" },
    },
  },


  -- Clipboard: OSC52 (vim-oscyank)
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


  -- Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },  -- Markdown のときのみ読み込む（軽量化）
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      render_modes = { "n", "c", "i" },

      sign = { enabled = false, },
      heading = {
        enabled = true,
        icons = {  -- display icon
          "#1. ", "#2. ", "#3. ", "#4. ", "#5. ", "#6. ",
        },
      },
      bullet = { enabled = true, },
      checkbox = { enabled = true, },

      -- display as plain only the cursor line
      anti_conceal = {
        enabled = true,
        above = 0,
        below = 0,
      },
    },
    keys = {
      {
        "<leader>m",
        function()
          require("render-markdown").toggle()
        end,
        mode = "n",
        desc = "Toggle markdown render",
      },
    },

    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- heading setting
      local function set_markdown_hl()
        local title = vim.api.nvim_get_hl(0, { name = "Title" })
        title.bold = true

        vim.api.nvim_set_hl(0, "Title", title)

        for i = 1, 6 do
          vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", {
              link = "Title",
          })
        end
      end

      set_markdown_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
          callback = set_markdown_hl,
      })
    end,
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "lua",
        "python",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "latex",
        "make",
        "vim",
        "vimdoc",
        "gnuplot",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },

  -- pin headers
  {
    "nvim-treesitter/nvim-treesitter-context",

    opts = {
      multiline_threshold = 3,
      max_lines = 5,
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    opts = {
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
      },
    },

    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = true,  -- gitignore を無視
          })
        end,
        desc = "Find files",
      },

      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live grep",
      },

      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },

      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help tags",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",

    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
  -- mason
  {
    "williamboman/mason.nvim",

    opts = {
      ui = {
        check_outdated_packages_on_open = false,
        border = "single",
      },
    },
  },
  -- mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "lua_ls",
        "pyright",
      },
    },
    automatic_enable = true,
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },

    event = "InsertEnter",

    config = function()
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["S-<Tab>"] = cmp.mapping.select_prev_item(),
        }),
      })
    end,
  },

  -- formatter
  {
    "stevearc/conform.nvim",

    opts = {
      formatters_by_ft = {
        lua = { "stylua" },

        python = { "black" },

        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        c = { "clang_format" },
        cpp = { "clang_format" },

        json = { "jq" },

        markdown = { "prettier" },
        yaml = { "prettier" },
      },
    },

    keys = {
      {
        "<leader><leader>",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        mode = "n",
        desc = "Format file",
      },
    },
  },

  -- lint
  {
    "mfussenegger/nvim-lint",

    event = {
      "BufReadPre",
      "BufNewFile",
    },

    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "ruff" },

        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
      }

      vim.api.nvim_create_autocmd({
          "BufWritePost",
          "InsertLeave",
        }, {
          callback = function()
            lint.try_lint()
          end,
      })
    end,
  },

}, {
  lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
})
