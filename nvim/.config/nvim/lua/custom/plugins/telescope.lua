return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim" ,
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
  keys = {
    { "<leader>sg",
      function() require('telescope').extensions.live_grep_args.live_grep_args({ hidden = true }) end,
      desc = "Live grep args",
    }
  },
}
