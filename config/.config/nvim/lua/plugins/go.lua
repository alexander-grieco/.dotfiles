return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local go = require("go")
    go.setup()
    vim.keymap.set("n", "<leader>gr", ":GoRun % -F<CR>", { desc = "Go run" })
    vim.keymap.set("n", "<leader>gch", ":GoCheat ", { desc = "Go chead sheet" })
    vim.keymap.set("n", "<leader>gD", ":GoDoc ", { desc = "Open Go Doc command" })
    vim.keymap.set("n", "<leader>gd", function()
      -- call GoDoc
      local buffers_before = vim.api.nvim_list_bufs()
      vim.cmd(":GoDoc")
      vim.defer_fn(function()
        local buffers_after = vim.api.nvim_list_bufs()

        -- Make sure a buffer was opened
        -- if not, then GoDoc didn't find anything
        if #buffers_after > #buffers_before then
          vim.cmd('wincmd w')
        end
      end, 100)
    end, { desc = "Go doc" })
    vim.keymap.set("n", "<leader>gtf", ":GoTestFile<CR>", { desc = "Go test current file" })
    vim.keymap.set("n", "<leader>gtc", ":GoTestFunc<CR>", { desc = "Go test current function" })
    vim.keymap.set("n", "<leader>gtp", ":GoTest -p<CR>", { desc = "Go test current package" })

    -- Run gofmt + goimports on save
    local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require('go.format').goimports()
      end,
      group = format_sync_grp,
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", 'gomod' },
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}
