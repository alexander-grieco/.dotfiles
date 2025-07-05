return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "folke/snacks.nvim", -- optional
    },
    config = true,
    -- keys = {
    -- Moved to keymaps.lua -> otherwise race condition with Snack.nvim package, even when disabling that keymap
    -- },
  },
}
