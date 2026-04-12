return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    workspaces = {
      {
        name = "DB",
        path = "~/Nextcloud/DB",
      },
    },
  },
  keys = {
    -- Top level commands
    {
      "<leader>odd",
      "<cmd>Obsidian dailies -7 0<cr>",
      desc = "Dailies (last 7 days)",
    },
    {
      "<leader>odh",
      "<cmd>Obsidian help<cr>",
      desc = "Help",
    },
    {
      "<leader>odg",
      "<cmd>Obsidian helpgrep<cr>",
      desc = "Help grep",
    },
    {
      "<leader>odn",
      function()
        local title = vim.fn.input("Note title: ")
        if title ~= "" then
          vim.cmd("Obsidian new " .. title)
        end
      end,
      desc = "New note",
    },
    {
      "<leader>odo",
      function()
        local query = vim.fn.input("Open note (query): ")
        if query ~= "" then
          vim.cmd("Obsidian open " .. query)
        else
          vim.cmd("Obsidian open")
        end
      end,
      desc = "Open in Obsidian app",
    },
    {
      "<leader>odt",
      "<cmd>Obsidian today<cr>",
      desc = "Today's daily note",
    },
    {
      "<leader>odT",
      "<cmd>Obsidian tomorrow<cr>",
      desc = "Tomorrow's daily note",
    },
    {
      "<leader>odY",
      "<cmd>Obsidian yesterday<cr>",
      desc = "Yesterday's daily note",
    },
    {
      "<leader>odN",
      function()
        local title = vim.fn.input("Note title: ")
        local template = vim.fn.input("Template name (empty for picker): ")
        if title ~= "" and template ~= "" then
          vim.cmd("Obsidian new_from_template " .. title .. " " .. template)
        elseif title ~= "" then
          vim.cmd("Obsidian new_from_template " .. title)
        else
          vim.cmd("Obsidian new_from_template")
        end
      end,
      desc = "New note from template",
    },
    {
      "<leader>odq",
      "<cmd>Obsidian quick_switch<cr>",
      desc = "Quick switch",
    },
    {
      "<leader>ods",
      function()
        local query = vim.fn.input("Search: ")
        if query ~= "" then
          vim.cmd("Obsidian search " .. query)
        else
          vim.cmd("Obsidian search")
        end
      end,
      desc = "Search notes",
    },
    {
      "<leader>od#",
      function()
        local tags = vim.fn.input("Tags (space-separated): ")
        if tags ~= "" then
          vim.cmd("Obsidian tags " .. tags)
        end
      end,
      desc = "Search by tags",
    },
    {
      "<leader>odw",
      function()
        local name = vim.fn.input("Workspace name: ")
        if name ~= "" then
          vim.cmd("Obsidian workspace " .. name)
        end
      end,
      desc = "Switch workspace",
    },

    -- Note commands
    {
      "<leader>onb",
      "<cmd>Obsidian backlinks<cr>",
      desc = "Backlinks",
    },
    {
      "<leader>onf",
      "<cmd>Obsidian follow_link<cr>",
      desc = "Follow link",
    },
    {
      "<leader>onv",
      "<cmd>Obsidian follow_link vsplit<cr>",
      desc = "Follow link (vsplit)",
    },
    {
      "<leader>onh",
      "<cmd>Obsidian follow_link hsplit<cr>",
      desc = "Follow link (hsplit)",
    },
    {
      "<leader>onc",
      "<cmd>Obsidian toc<cr>",
      desc = "Table of contents",
    },
    {
      "<leader>oni",
      "<cmd>Obsidian template<cr>",
      desc = "Insert template",
    },
    {
      "<leader>onl",
      "<cmd>Obsidian links<cr>",
      desc = "Links in current note",
    },
    {
      "<leader>onp",
      function()
        local name = vim.fn.input("Image name (empty for default): ")
        if name ~= "" then
          vim.cmd("Obsidian paste_img " .. name)
        else
          vim.cmd("Obsidian paste_img")
        end
      end,
      desc = "Paste image",
    },
    {
      "<leader>onr",
      function()
        local name = vim.fn.input("New name: ")
        if name ~= "" then
          vim.cmd("Obsidian rename " .. name)
        end
      end,
      desc = "Rename note",
    },
    {
      "<leader>onx",
      "<cmd>Obsidian toggle_checkbox<cr>",
      desc = "Toggle checkbox",
    },

    -- Visual mode commands
    {
      "<leader>ove",
      function()
        local title = vim.fn.input("Extract note title: ")
        if title ~= "" then
          vim.cmd("'<,'>Obsidian extract_note " .. title)
        end
      end,
      mode = "v",
      desc = "Extract to new note",
    },
    {
      "<leader>ovl",
      "<cmd>'<,'>Obsidian link<cr>",
      mode = "v",
      desc = "Link selection to note",
    },
    {
      "<leader>ovn",
      function()
        local title = vim.fn.input("New linked note title (empty for selection): ")
        if title ~= "" then
          vim.cmd("'<,'>Obsidian link_new " .. title)
        else
          vim.cmd("'<,'>Obsidian link_new")
        end
      end,
      mode = "v",
      desc = "Link selection to new note",
    },
  },
}
