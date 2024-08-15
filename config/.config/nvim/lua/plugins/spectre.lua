return {

  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("spectre").setup {
      default = {
        find = {
          options = { "hidden" },
        },
        replace = {
          options = { "hidden" },
        },
      },
    }
  end,
  keys = {
    {
      "<leader>S",
      function()
        require("spectre").toggle()
      end,
      desc = "Toggle Spectre",
    },
    {
      "<leader>sw",
      function()
        require("spectre").open_visual { select_word = true }
      end,
      desc = "Search current word",
    },
    {
      mode = "v",
      "<leader>sw",
      function()
        require("spectre").open_visual()
      end,
      desc = "Search current word",
    },
    {
      "<leader>sp",
      function()
        require("spectre").open_file_search { select_word = true }
      end,
      desc = "Search on current file",
    },
  },
}
