-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "s", "<nop>")

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

-- Increment all numbers in visual selection
vim.keymap.set(
  "v",
  "<leader>vi",
  ":s/\\%V\\d\\+\\%V/\\=submatch(0)+1/g<CR>gv=gv",
  { desc = "[I]ncrement Numbers, or <C-a>" }
)
-- Decrement all numbers in visual selection
vim.keymap.set(
  "v",
  "<leader>vd",
  ":s/\\%V\\d\\+\\%V/\\=submatch(0)-1/g<CR>gv=gv",
  { desc = "[D]ecrement Numbers, or <C-x>" }
)

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
vim.keymap.set(
  "n",
  "<leader>lq",
  ":call setloclist(0, [], 'r')<CR>:lcl<CR>",
  { desc = "loclist list clear for current window" }
)
vim.keymap.set("n", "<leader>lc", ":lcl<CR>", { desc = "loclist list close for current window" })

-- neogit
vim.keymap.set("n", "<leader>gs", function()
  require("neogit").open({})
end, { desc = "Open Neogit" })
