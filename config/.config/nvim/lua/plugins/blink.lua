return {
  {
    "saghen/blink.compat",
    lazy = true,
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    opts = {},
    config = function()
      -- monkeypatch cmp.ConfirmBehavior for Avante
      require("cmp").ConfirmBehavior = {
        Insert = "insert",
        Replace = "replace",
      }
    end,
  },
  {
    "saghen/blink.cmp",
    -- version = "1.*",
    build = "cargo build --release",
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      build = "cargo build --release",
      fuzzy = { implementation = "prefer_rust" },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          -- "copilot",
          -- "avante_mentions",
          -- "avante_files",
          -- "avante_commands",
        },
        providers = {
          lsp = {
            score_offset = 10000,
          },
          -- copilot = {
          --   name = "copilot",
          --   module = "blink-cmp-copilot",
          --   score_offset = -100,
          --   async = true,
          --   transform_items = function(_, items)
          --     local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          --     local kind_idx = #CompletionItemKind + 1
          --     CompletionItemKind[kind_idx] = "Copilot"
          --     for _, item in ipairs(items) do
          --       item.kind = kind_idx
          --     end
          --     return items
          --   end,
          -- },
          -- Avante completion for when this works
          -- avante_commands = {
          --   name = "avante_commands",
          --   module = "blink.compat.source",
          --   score_offset = -90,
          --   opts = {},
          -- },
          -- avante_files = {
          --   name = "avante_commands",
          --   module = "blink.compat.source",
          --   score_offset = -100,
          --   opts = {},
          -- },
          -- avante_mentions = {
          --   name = "avante_mentions",
          --   module = "blink.compat.source",
          --   score_offset = -1000,
          --   opts = {},
          -- },
        },
      },
      keymap = {
        preset = "default",

        -- Make tab and shift-tab do nothing
        ["<S-Tab>"] = {},
        ["<Tab>"] = {},
      },
      signature = { enabled = true },
      appearance = {
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
        kind_icons = {
          Copilot = "",
          Text = "󰉿",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓",

          Field = "󰜢",
          Variable = "󰆦",
          Property = "󰖷",

          Class = "󱡠",
          Interface = "󱡠",
          Struct = "󱡠",
          Module = "󰅩",

          Unit = "󰪚",
          Value = "󰦨",
          Enum = "󰦨",
          EnumMember = "󰦨",

          Keyword = "󰻾",
          Constant = "󰏿",

          Snippet = "󱄽",
          Color = "󰏘",
          File = "󰈔",
          Reference = "󰬲",
          Folder = "󰉋",
          Event = "󱐋",
          Operator = "󰪚",
          TypeParameter = "󰬛",
        },
      },
    },
  },
}
