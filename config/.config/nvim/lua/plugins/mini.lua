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

    -- -- Highlight current word
    -- require("mini.cursorword").setup()

    -- Autopairs
    require("mini.pairs").setup()

    require("mini.icons").setup()

    -- Trim extraneous whitespace
    require("mini.trailspace").setup()

    -- Simple and easy statusline.
    local statusline = require "mini.statusline"
    statusline.setup({
      content = {
        active = function()
          local mode, mode_hl   = statusline.section_mode({ trunc_width = 120 })
          local git             = statusline.section_git({ trunc_width = 40 })
          local diff            = statusline.section_diff({ trunc_width = 75 })
          local diagnostics     = statusline.section_diagnostics({ trunc_width = 75 })
          local lsp             = statusline.section_lsp({ trunc_width = 75 })
          local filename        = statusline.section_filename({ trunc_width = 140 })
          local fileinfo        = statusline.section_fileinfo({ trunc_width = 120 })
          local location        = statusline.section_location({ trunc_width = 75 })
          local search          = statusline.section_searchcount({ trunc_width = 75 })
          local macro_recording = vim.fn.reg_recording()

          -- Adds macro recording status
          local macro_status    = ""
          if macro_recording ~= "" then
            macro_status = string.format("Recording @%s", macro_recording)
          end

          -- return table.concat({ mode, git, diagnostics, filename, fileinfo, macro_status }, " ")
          return MiniStatusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl,                  strings = { macro_status } },
            { hl = mode_hl,                  strings = { search, location } },
          })
        end,
        inactive = nil,
      },
    })
    statusline.section_location = function()
      return "%2l:%-2v"
    end
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim


    -- Fix terraform and hcl comment string
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
      callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
      end,
      pattern = { "terraform", "hcl" },
    })
  end,
}
