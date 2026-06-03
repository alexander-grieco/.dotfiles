return {
  "alex35mil/pi.nvim",

  -- Optional: required only for `:PiPasteImage` (clipboard image paste).
  dependencies = { "HakonHarnes/img-clip.nvim" },

  -- if you're fine with defaults:
  config = true,

  -- -- or, if you want to customize:
  -- opts = {
  --     models = { ... },
  --     layout = { ... },
  -- },
  keys = {
    {
      "<Leader>pp",
      function()
        vim.cmd("Pi layout=side")
      end,
      desc = "Pi side",
    },
    {
      "<Leader>pf",
      function()
        vim.cmd("Pi layout=float")
      end,
      desc = "Pi float",
    },
    { "<Leader>pl", "<Cmd>PiToggleLayout<CR>", desc = "Pi toggle layout" },
    { "<Leader>pc", "<Cmd>PiContinue<CR>", desc = "Pi continue last session" },
    { "<Leader>pr", "<Cmd>PiResume<CR>", desc = "Pi resume past session" },
    { "<Leader>pm", "<Cmd>PiSendMention<CR>", desc = "Pi mention file/selection" },
    { "<Leader>pa", "<Cmd>PiAttention<CR>", desc = "Pi open next attention request" },
    { "<Leader>pss", "<Cmd>PiStop<CR>", desc = "Stop Pi process" },
    { "<Leader>psa", "<Cmd>PiSelectModelAll<CR>", desc = "Select Pi model" },
    { "<Leader>psn", "<Cmd>PiNewSession<CR>", desc = "Start new Pi session" },
  },
}
