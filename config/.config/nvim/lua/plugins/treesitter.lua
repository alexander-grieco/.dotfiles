return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }

    -- Additional nvim-treesitter modules that can be used to interact with nvim-treesitter.
    --    - Incremental selection: Included, see :help nvim-treesitter-incremental-selection-mod
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
