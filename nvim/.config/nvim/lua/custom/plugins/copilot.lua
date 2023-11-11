return {
  'github/copilot.vim',
  keys = {
    {
      "<leader>ci",
      'copilot#Accept("<CR>")',
      desc = "Accept copilot suggestion"
    },
    {
      "<leader>cp",
      ':Copilot<CR>',
      desc = "Call Copilot",
    }
  },

}
