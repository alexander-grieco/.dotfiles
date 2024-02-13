return {
  -- Bring up netrw
  vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>"),

  -- Buffer navigation
  vim.keymap.set("n", "<leader>bn", ":bn<CR>", { desc = '[B]uffer [N]ext' }),
  vim.keymap.set("n", "<leader>bp", ":bp<CR>", { desc = '[B]uffer [P]revious' }),

  -- Visual mode move highlighted text
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move Line Down' }),
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move Line Up' }),

  -- append line below to current line, keep cursor at current location
  vim.keymap.set("n", "J", "mzJ`z", { desc = 'Append line below to current line' }),

  -- page up/down keeps cursor in middle of page
  vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Page Down' }),
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Page Up' }),

  -- when searching for terms, keep cursor in middle of terminal
  vim.keymap.set("n", "n", "nzzzv", { desc = 'Next term' }),
  vim.keymap.set("n", "N", "Nzzzv", { desc = 'Previous term' }),

  -- when pasting over via highligh, keep current pasted item in memory
  vim.keymap.set("x", "p", [["_dP]], { desc = '' }),
  vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]),
  -- yank to global clipboard
  vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]),

  -- Copy full file (remain at same place in file)
  vim.keymap.set("n", "<leader>Y", "gg\"+yG<C-o>", { desc = "Full file copy" }),

  -- I've been told Q is the worst place in the universe
  vim.keymap.set("n", "Q", "<nop>"),

  -- Plenary Test remap
  vim.keymap.set("n", "<leader>pt", "<Plug>PlenaryTestFile", { desc = "[P]lenary [T]est" }),

  -- Increment all numbers in visual selection
  vim.keymap.set("v", "<leader>vi", ':s/\\%V\\d\\+\\%V/\\=submatch(0)+1/g<CR>gv=gv',
    { desc = "[I]ncrement Numbers, or <C-a>" }),
  -- Decrement all numbers in visual selection
  vim.keymap.set("v", "<leader>vd", ':s/\\%V\\d\\+\\%V/\\=submatch(0)-1/g<CR>gv=gv',
    { desc = "[D]ecrement Numbers, or <C-x>" }),

  -- Set up sed command on current word
  vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace current word" }),

  -- Make current file executable
  vim.keymap.set("n", "<leader>x", "<cmd>silent !chmod +x %<CR>", { silent = true, desc = "Make e[X]ecutable" }),

  -- Run tmux-sessionizer from within nvim
  vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "tmux-sessionizer" }),

  -- Quickfix remaps
  vim.keymap.set("n", "<C-j>", ":cnext<CR>", { desc = "quickfix list next" }),
  vim.keymap.set("n", "<C-k>", ":cprev<CR>", { desc = "quickfix list prev" }),
  vim.keymap.set("n", "<leader>co", ":copen<CR>", { desc = "quickfix list open" }),
  vim.keymap.set("n", "<leader>cc", ":copen<CR>:q!<CR>", { desc = "quickfix list close" }),
  vim.keymap.set("n", "<leader>cq", ":call setqflist([], 'r')<CR>", { desc = "quickfix list clear" }),
  vim.keymap.set("n", "<leader>fr", ":cdo %s@@@g<Left><Left><Left>", { desc = "Find and replace (in quickfixlist)" }),
  vim.keymap.set("n", "<leader>fwr", [[:cdo %s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Find current word and replace (in quickfixlist)" }),

  -- Format json
  vim.keymap.set("n", "<leader>fj", ":%!jq '.'<CR>", { desc = "format json file" }),

  -- Register two key keymap titles
  require('which-key').register({
    ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
    ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
    ['<leader>fw'] = { name = '[F]ind word', _ = 'which_key_ignore' },
  })

}
