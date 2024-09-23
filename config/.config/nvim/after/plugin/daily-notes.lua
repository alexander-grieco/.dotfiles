-- Function to insert the template at the beginning of the current buffer
local function insert_template()
  -- Define the hardcoded path to the template file
  local template_path = vim.fn.expand("~/Documents/B_Product_Development/daily-notes/daily-template.md")

  -- Check if the template file exists
  local template_file = io.open(template_path, "r")
  if not template_file then
    print("Template file does not exist: " .. template_path)
    return
  end

  -- Read the contents of the template
  local template_content = template_file:read("*all")
  template_file:close()

  -- Get the current date in the desired format (e.g., YYYY-MM-DD)
  local current_date = os.date("%Y-%m-%d")

  -- Replace the {{DATE}} placeholder with the current date in the template content
  template_content = template_content:gsub("{{DATE}}", current_date)

  -- Get the current buffer contents
  local current_buf = vim.api.nvim_get_current_buf()
  local current_lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

  -- Convert the current file contents to a single string
  local current_content = table.concat(current_lines, "\n")

  -- Prepend the template content to the current file content
  local new_content = template_content .. "\n" .. current_content

  -- Set the new content in the buffer, replacing all lines
  local new_lines = {}
  for line in new_content:gmatch("([^\n]*)\n?") do
    table.insert(new_lines, line)
  end

  vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, new_lines)

  -- Inform the user
  print("Template inserted at the beginning of the current file.")
end

-- Create a Neovim command to trigger the function
vim.api.nvim_create_user_command("InsertTemplate", function()
  insert_template()
end, {})


-- Creates a floating window with the daily-notes file opened in it
local function open_floating_file()
  -- Define the path to the specific file you want to open
  local file_path = vim.fn.expand("~/Documents/B_Product_Development/daily-notes/daily-notes.md")

  -- Define floating window dimensions
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a floating window
  local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  })

  -- Load the file into the buffer
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.cmd("edit " .. file_path)

  -- Set an autocommand to save the file when the floating window loses focus
  vim.api.nvim_create_autocmd({ "BufWinLeave", "BufHidden" }, {
    buffer = buf,
    callback = function()
      -- Save the file
      vim.cmd("silent! write")
      print("File saved: " .. file_path)
    end,
    group = vim.api.nvim_create_augroup("AutoSaveOnBufWinLeave", { clear = true }),
  })

  -- Optional: Set keybindings to close the floating window with <Esc>
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })

  -- Optional: Inform the user about the floating buffer
  print("Opened " .. file_path .. " in a floating buffer.")
end

-- Create a Neovim command to trigger the function
vim.api.nvim_create_user_command("OpenDailyNote", function()
  open_floating_file()
end, {})
