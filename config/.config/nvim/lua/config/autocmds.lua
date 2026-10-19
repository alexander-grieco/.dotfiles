-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- MDX needs {/* */} comments; mini.comment otherwise picks <!-- --> from the markdown/html treesitter parsers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown.mdx",
  callback = function()
    vim.b.minicomment_config = {
      options = {
        custom_commentstring = function()
          return "{/* %s */}"
        end,
      },
    }
  end,
})

vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})
