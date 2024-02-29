local tab_len = 2

local options = {
  guicursor = '',
  tabstop = tab_len,
  softtabstop = tab_len,
  relativenumber = true,
  shiftwidth = tab_len,
  expandtab = true,
  smartindent = true,
  incsearch = true,
  -- Give more space for displaying messages.
  cmdheight = 1,
  -- filetype = 'on', -- handled by filetypefiletype = 'on' --lugin
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
