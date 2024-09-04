return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "HiPhish/rainbow-delimiters.nvim",
  },
  main = "ibl",
  opts = {},
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }
    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- csvCol0 is just a collection of color definitions I found in the 0 namespace - just seemed to work well
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = vim.api.nvim_get_hl(0, { name = "csvCol0", create = false }).fg })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = vim.api.nvim_get_hl(0, { name = "csvCol1", create = false }).fg })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = vim.api.nvim_get_hl(0, { name = "csvCol2", create = false }).fg })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = vim.api.nvim_get_hl(0, { name = "csvCol3", create = false }).fg })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = vim.api.nvim_get_hl(0, { name = "csvCol4", create = false }).fg })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = vim.api.nvim_get_hl(0, { name = "csvCol5", create = false }).fg })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = vim.api.nvim_get_hl(0, { name = "csvCol6", create = false }).fg })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require("ibl").setup({ scope = { highlight = highlight } })

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
