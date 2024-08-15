-- NOTE: Plugins can also be configured to run lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key after all the UI elements are loaded. Events can be
-- normal autocommands events (:help autocomd-events).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VeryEnter'
  priority = 800,
  config = function() -- This is the function that runs, AFTER loading
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").add {
      { "<leader>d", name = "[D]ocument" },
      { "<leader>r", name = "[R]ename" },
      { "<leader>s", name = "[S]earch" },
      { "<leader>w", name = "[W]orkspace" },
      { "<leader>h", name = "Gitsigns Functions" },
      { "<leader>b", name = "[B]uffer" },
      { "<leader>o", name = "[O]nly current buffer" },
      { "<leader>l", name = "[L]oclist Operations" },
      { "<leader>c", name = "Qui[C]kfix Operations" },
      { "<leader>x", name = "Trouble Operations" },
    }
  end,
}
