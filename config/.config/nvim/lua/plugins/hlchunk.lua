return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        priority = 100,
        textobject = "ic",
        use_treesitter = true,
        enable = true,
        style = {
          "#f4b8e4",
          "#e78284",
        },
        duration = 230,
      },
      indent = {
        enable = true,
        chars = {
          "│",
          "¦",
          "┆",
          "┊",
        },
      },
      line_num = {
        enable = true,
        style = {
          "#f4b8e4",
        },
      },
    })
  end
}
