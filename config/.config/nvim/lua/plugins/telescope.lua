return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- {
    --   "nvim-telescope/telescope-fzf-native.nvim",
    --   build = "make",
    --
    --   -- `cond` is a condition used to determine whether this plugin should be
    --   -- installed and loaded.
    --   cond = function()
    --     return vim.fn.executable("make") == 1
    --   end,
    -- },
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`

    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")
    -- local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
    -- require("config.telescope.multigrep").setup()
    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          -- Ignore git files, but not .github files
          "^%.git%/.-",
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = actions.delete_buffer,
            ["<C-h>"] = "which_key",
            ["<C-q>"] = actions.add_to_qflist + actions.open_qflist,
            ["<C-w>"] = actions.add_selected_to_qflist + actions.open_qflist,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--no-ignore",
          "--smart-case",
          "--hidden",
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          mappings = { -- extend mappings
            i = {
              ["<C-i>"] = lga_actions.quote_prompt(),
              ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t" }),
              ["<C-q>"] = actions.add_to_qflist + actions.open_qflist,
              ["<C-w>"] = actions.add_selected_to_qflist + actions.open_qflist,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        },
        -- fzf = {
        --   fuzzy = true, -- false will only do exact matching
        --   override_generic_sorter = true, -- override the generic sorter
        --   override_file_sorter = true, -- override the file sorter
        --   case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        --   -- the default case_mode is "smart_case"
        -- },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    -- Enable telescope extensions, if they are installed
    -- pcall(telescope.load_extension, "fzf")
    -- pcall(telescope.load_extension, "ui-select")
    -- pcall(telescope.load_extension, "live_grep_args")
    -- telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("live_grep_args")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set(
      "n",
      "<leader>sg",
      telescope.extensions.live_grep_args.live_grep_args,
      { desc = "[S]earch by [G]rep" }
    )
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    -- -- Shortcut for searching your neovim configuration files
    -- vim.keymap.set("n", "<leader>sn", function()
    --   local opts = require("telescope.themes").get_ivy({
    --     cwd = vim.fn.stdpath("config")
    --   })
    --   require('telescope.builtin').find_files(opts)
    -- end, { desc = "[S]earch [N]eovim files" })
  end,
}
