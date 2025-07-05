return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = false },
  },
  keys = {
    -- git
    -- Disable git status in favour of neogit activation keymap
    { "<leader>gs", false },
  },
}
