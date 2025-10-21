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
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "default",

        -- Make tab and shift-tab do nothing
        ["<S-Tab>"] = {},
        ["<Tab>"] = {},
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
        kind_icons = {
          Supermaven = "",
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

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "supermaven", "lsp", "path", "snippets", "buffer" },
        providers = {
          supermaven = {
            name = "supermaven",
            module = "blink.compat.source",
            async = true,
            score_offset = 10000000,
          },
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

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
