-- Bring up netrw
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")

-- Octo GitHub
vim.keymap.set("n", "<leader>prl", "<cmd>Octo pr list<CR>")
vim.keymap.set("n", "<leader>pro", ":Octo pr list ")
vim.keymap.set("n", "<leader>prc", "<cmd>Octo pr create<CR>")
vim.keymap.set("n", "<leader>prr", "<cmd>Octo pr reload<CR>")

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<C-n>", ":bn<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<C-p>", ":bp<CR>", { desc = "[B]uffer [P]revious" })

-- Visual mode move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up" })

-- append line below to current line, keep cursor at current location
vim.keymap.set("n", "J", "mzJ`z", { desc = "Append line below to current line" })

-- page up/down keeps cursor in middle of page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page Up" })

-- when searching for terms, keep cursor in middle of terminal
vim.keymap.set("n", "n", "nzzzv", { desc = "Next term" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous term" })

-- when pasting over via highligh, keep current pasted item in memory
vim.keymap.set("x", "p", [["_dP]], { desc = "" })

-- When deleting keep current pasted item in memory
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Copy full file (remain at same place in file)
vim.keymap.set("n", "<leader>Y", 'gg"+yG<C-o>')

-- I've been told Q is the worst place in the universe
vim.keymap.set("n", "Q", "<nop>")

-- Plenary Test remap (for plugin development)
vim.keymap.set("n", "<leader>pt", "<Plug>PlenaryTestFile", { desc = "[P]lenary [T]est" })

-- Increment all numbers in visual selection
vim.keymap.set("v", "<leader>vi", ":s/\\%V\\d\\+\\%V/\\=submatch(0)+1/g<CR>gv=gv",
  { desc = "[I]ncrement Numbers, or <C-a>" })
-- Decrement all numbers in visual selection
vim.keymap.set("v", "<leader>vd", ":s/\\%V\\d\\+\\%V/\\=submatch(0)-1/g<CR>gv=gv",
  { desc = "[D]ecrement Numbers, or <C-x>" })

-- Set up sed command on current word
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace current word" })

-- Run tmux-sessionizer from within nvim
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "tmux-sessionizer" })

-- Quickfix remaps
vim.keymap.set("n", "<leader>cj", ":cnext<CR>", { desc = "quickfix list next" })
vim.keymap.set("n", "<leader>ck", ":cprev<CR>", { desc = "quickfix list prev" })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { desc = "quickfix list open" })
vim.keymap.set("n", "<leader>cc", ":ccl<CR>", { desc = "quickfix list close" })
vim.keymap.set("n", "<leader>cq", ":call setqflist([], 'f')<CR>", { desc = "quickfix list clear" })

-- Loclist remaps
vim.keymap.set("n", "<C-s>", ":lnext<CR>", { desc = "quickfix list next" })
vim.keymap.set("n", "<C-a>", ":lprev<CR>", { desc = "quickfix list prev" })
vim.keymap.set("n", "<leader>lo", ":lop<CR>", { desc = "loclist list open for current window" })
vim.keymap.set("n", "<leader>lq", ":call setloclist(0, [], 'r')<CR>:lcl<CR>",
  { desc = "loclist list clear for current window" })
vim.keymap.set("n", "<leader>lc", ":lcl<CR>", { desc = "loclist list close for current window" })

-- Close all but current buffer
vim.keymap.set("n", "<leader>o", ":only<CR>", { desc = "Close all but current buffer" })

-- Daily Notes
vim.keymap.set("n", "<leader>do", ":OpenDailyNote<CR>", { desc = "Open Daily Note file in floating buffer" })
vim.keymap.set("n", "<leader>di", ":InsertTemplate<CR>", { desc = "Insert Daily Note Template" })
