return {
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      async = true,
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
      formatters = {
        -- Custom formatter for HCL config files
        hcl_fmt = {
          command = "nomad",
          args = { "fmt", "-recursive", "-list=false", "." },
          stdin = false,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        terraform = { "terraform_fmt" },
        yaml = { "yq" },
        json = { "jq" },
        toml = { "taplo" },
        hcl = { "hcl_fmt" },
        rust = { "rustfmt" },
        nomad = { "nomad_fmt" },
        go = { "gofmt", "goimports" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Highlight todo, notes, etc in comments
  { "folke/todo-comments.nvim", event = "VimEnter", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },
}
