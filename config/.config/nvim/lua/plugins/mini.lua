return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]parenthen
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    -- Search forward/backward
    require("mini.bracketed").setup()

    -- Comment Lines
    require("mini.comment").setup()

    -- Completion help
    require("mini.completion").setup()

    -- Highlight current word
    require("mini.cursorword").setup()

    -- Autopairs
    require("mini.pairs").setup()

    -- Tabbed buffers
    require("mini.icons").setup()
    require("mini.tabline").setup()

    -- Trim extraneous whitespace
    require("mini.trailspace").setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require "mini.statusline"
    statusline.setup()
    statusline.section_location = function()
      return "%2l:%-2v"
    end
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
