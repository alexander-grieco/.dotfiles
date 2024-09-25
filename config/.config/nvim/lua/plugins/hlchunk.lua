return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        textobject = "ic",
        use_treesitter = true,
        enable = true,
        style = {
          "#00ffff",
          "#c21f30",
        },
        duration = 230,
      },
      indent = {
        enable = true
      },
      line_num = {
        enable = true
      },
    })
  end
}
