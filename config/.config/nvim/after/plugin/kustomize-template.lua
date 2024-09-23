-- Create a user command with an inline function
vim.api.nvim_create_user_command('InsertKustomizationConfig', function()
  local lines = {
    "apiVersion: kustomize.config.k8s.io/v1beta1",
    "kind: Kustomization",
    "",
    "resources:",
    "  - \"\"",
  }
  -- Insert the lines at the top of the current buffer
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end, {})

vim.api.nvim_set_keymap('n', '<leader>ik', ':InsertKustomizationConfig<CR>', { noremap = true, silent = true })
