-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable the weird slow transition stuff - I don't like it
vim.g.snacks_animate = false

-- Create a user command with an inline function
-- For blank Kustomization files
vim.api.nvim_create_user_command("InsertKustomizationConfig", function()
  local lines = {
    "apiVersion: kustomize.config.k8s.io/v1beta1",
    "kind: Kustomization",
    "",
    "resources:",
    '  - ""',
  }
  -- Insert the lines at the cursor
  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end, {})

vim.api.nvim_set_keymap("n", "<leader>ik", ":InsertKustomizationConfig<CR>", { noremap = true, silent = true })
