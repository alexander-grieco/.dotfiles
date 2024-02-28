return {
  'nvim-telescope/telescope.nvim',
  keys = {
    {
      "<leader>sg",
      function() require('telescope').extensions.live_grep_args.live_grep_args({ hidden = true }) end,
      desc = "Live grep args",
    }
  },
}

