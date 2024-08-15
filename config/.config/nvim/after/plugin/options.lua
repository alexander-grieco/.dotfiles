local tab_len = 2

local options = {
  -- Make line numbers default
  number = true,
  -- You can also add relative line numbers, for help with jumping.
  --  Experiment for yourself to see if you like it!
  relativenumber = true,

  -- Enable mouse mode, can be useful for resizing splits for example!
  mouse = "a",

  -- Don't show the mode, since it's already in status line
  showmode = false,

  -- Sync clipboard between OS and Neovim.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  clipboard = "unnamedplus",

  -- Enable break indent
  breakindent = true,

  -- Save undo history
  undofile = true,

  -- Case-insensitive searching UNLESS \C or capital in search
  ignorecase = true,
  smartcase = true,

  -- Keep signcolumn on by default
  signcolumn = "yes",

  -- Decrease update time
  updatetime = 250,
  timeoutlen = 300,

  -- Configure how new splits should be opened
  splitright = true,
  splitbelow = true,

  -- Sets how neovim will display certain whitespace in the editor.
  --  See :help 'list'
  --  and :help 'listchars'
  list = true,
  listchars = { tab = "» ", trail = "·", nbsp = "␣" },

  -- Preview substitutions live, as you type!
  inccommand = "split",

  -- Show which line your cursor is on
  cursorline = true,

  -- Minimal number of screen lines to keep above and below the cursor.
  scrolloff = 10,

  -- My settings
  guicursor = "",
  tabstop = tab_len,
  softtabstop = tab_len,
  shiftwidth = tab_len,
  expandtab = true,
  smartindent = true,
  incsearch = true,
  -- Give more space for displaying messages.
  cmdheight = 1,
  -- filetype = 'on', -- handled by filetypefiletype = 'on' --lugin
}

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
