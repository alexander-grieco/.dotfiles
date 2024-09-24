return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        textobject = "ic",
        use_treesitter = false,
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
      -- line_num = {
      --   style = "#00ffff",
      --   enable = true
      -- }
    })
  end
}
