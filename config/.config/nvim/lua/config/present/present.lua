-- M is a colloquial standin for "modules"
local M = {}

local function create_floating_window(config, enter)
  if enter == nil then
    enter = false
  end
  -- Create a buffer
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, enter, config)

  return { buf = buf, win = win }
end


M.create_system_executor = function(program, opts)
  opts = opts or {}
  return function(block)
    local tempfile = ""
    if opts.file_suffix == nil then
      tempfile = vim.fn.tempname()
    else
      tempfile = vim.fn.tempname() .. opts.file_suffix
    end
    -- Build the full command by inserting the tempfile into the program arguments
    local full_command = { unpack(program) }
    table.insert(full_command, tempfile) -- Append tempfile to the command
    vim.fn.writefile(vim.split(block.body, "\n"), tempfile)
    local result = vim.system(full_command, { text = true }):wait()
    return vim.split(result.stdout, "\n")
  end
end

---Default executor for lua code
---@param block present.Block
local execute_lua_code = function(block)
  -- Override the default print function, to capture all of the output
  -- Store the original print function
  local original_print = print

  local output = {}

  -- Redefine the print function
  print = function(...)
    local args = { ... }
    local message = table.concat(vim.tbl_map(tostring, args), "\t")
    table.insert(output, message)
  end

  -- Call the provided function
  local chunk = loadstring(block.body)
  pcall(function()
    if not chunk then
      table.insert(output, " <<<BROKEN CODE>>> ")
    else
      chunk()
    end
    return output
  end)


  -- Restore the original print function
  print = original_print

  return output
end

local options = {
  executors = {
    lua = execute_lua_code,
    javascript = M.create_system_executor({ "node" }),
    python = M.create_system_executor({ "python3" }),
    golang = M.create_system_executor({ "go", "run" }, { file_suffix = ".go" }),
  }
}

M.setup = function(opts)
  opts = opts or {}
  opts.executors = opts.executors or {}

  opts.executors.lua = opts.executors.lua or execute_lua_code
  opts.executors.javascript = opts.executors.javascript or M.create_system_executor("node")
  opts.executors.golang = opts.executors.golang or M.create_system_executor("go run")

  options = opts
end

---@class present.Slides
---@field slides present.Slide[]: The slides of the file

---@class present.Slide
---@field title string: The title of the slide
---@field body string[]: The body of the slide
---@field blocks present.Block[]: A codeblock inside of a slide

---@class present.Block
---@field language string: The language of the code block
---@field body string: the body of the code block


---Takes some lines and parses them
---@param lines string[]: The lines in the buffer
---@return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  local current_slide = {
    title = "",
    body = {},
    blocks = {},
  }

  local separator = "^#"
  for _, line in ipairs(lines) do
    -- print(line, "find:", line:find(separator), "|")
    -- If line contains the separator
    if line:find(separator) then
      -- If the current slide has content (i.e. length is not zero)
      if #current_slide.title > 0 then
        -- Inser the current slide into the list of slides
        table.insert(slides.slides, current_slide)
      end
      current_slide = {
        title = line,
        body = {},
        blocks = {},
      }
    else
      table.insert(current_slide.body, line)
    end
  end
  -- After looping all lines, make sure to append remaining content
  table.insert(slides.slides, current_slide)

  for _, slide in ipairs(slides.slides) do
    local block = {
      language = nil,
      body = "",
    }
    local inside_block = false
    for _, line in ipairs(slide.body) do
      if vim.startswith(line, "```") then
        if not inside_block then
          inside_block = true
          block.language = string.sub(line, 4)
        else
          inside_block = false
          block.body = vim.trim(block.body)
          table.insert(slide.blocks, block)
        end
      else
        if inside_block then
          block.body = block.body .. line .. "\n"
        end
      end
    end
  end
  return slides
end

local create_window_configurations = function()
  local width = vim.o.columns
  local height = vim.o.lines

  local header_height = 1 + 2 -- 1 + border
  local footer_height = 1     -- no border
  local body_height = height - header_height - footer_height - 1

  return {
    background = {
      relative = "editor",
      width = width,
      height = height + 1,
      style = "minimal",
      col = 0,
      row = 0,
      zindex = 1,
    },
    header = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      border = "rounded",
      col = 0,
      row = 0,
      zindex = 20,
    },
    body = {
      relative = "editor",
      width = width - 8,
      -- height = height - 4,
      height = body_height,
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      style = "minimal",
      col = 8,
      row = 4,
      zindex = 3,
    },
    footer = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      -- Border on the top?
      -- border = { " ", " ", " ", " ", "", "", "", "" },
      col = 0,
      row = height - 1,
      zindex = 20,
    },
  }
end

local state = {
  parsed = {},
  current_slide = 1,
  floats = {},
}

local foreach_float = function(cb)
  for name, float in pairs(state.floats) do
    cb(name, float)
  end
end

local present_keymap = function(mode, key, callback)
  vim.keymap.set(mode, key, callback, {
    buffer = state.floats.body.buf
  })
end

M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  state.parsed = parse_slides(lines)
  state.current_slide = 1
  state.title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(opts.bufnr), ":t")

  -- Set windows with their content
  local windows = create_window_configurations()
  state.floats.background = create_floating_window(windows.background)
  state.floats.header = create_floating_window(windows.header)
  state.floats.footer = create_floating_window(windows.footer)
  state.floats.body = create_floating_window(windows.body, true)

  foreach_float(function(_, float)
    vim.bo[float.buf].filetype = "markdown"
  end)

  local set_slide_content = function(idx)
    local width = vim.o.columns
    local slide = state.parsed.slides[idx]

    -- Calculation to center title
    local padding = string.rep(" ", (width - #slide.title) / 2)

    -- Title with included padding
    local title = padding .. slide.title

    -- set body title
    vim.api.nvim_buf_set_lines(state.floats.header.buf, 0, -1, false, { title })
    -- set slide body
    vim.api.nvim_buf_set_lines(state.floats.body.buf, 0, -1, false, slide.body)


    -- Set footer
    local footer = string.format(
      "  %d / %d | %s",
      state.current_slide,
      #state.parsed.slides,
      state.title
    )
    vim.api.nvim_buf_set_lines(state.floats.footer.buf, 0, -1, false, { footer })
  end

  -- "n" for next slide
  present_keymap("n", "n", function()
    state.current_slide = math.min(state.current_slide + 1, #state.parsed.slides)
    set_slide_content(state.current_slide)
  end)

  -- "p" for next slide
  present_keymap("n", "p", function()
    state.current_slide = math.max(state.current_slide - 1, 1)
    set_slide_content(state.current_slide)
  end)

  -- "X" to execute code block
  local code_win = 0
  present_keymap("n", "X", function()
    local slide = state.parsed.slides[state.current_slide]
    local block = slide.blocks[1]
    if not block then
      print("No blocks on this page")
      return
    end

    local executor = options.executors[block.language]
    if not executor then
      print("No executor for language: " .. block.language)
      return
    end

    -- Table to capture print messages
    local output = { "# Code", "", "```" .. block.language }
    vim.list_extend(output, vim.split(block.body, "\n"))
    table.insert(output, "```")

    table.insert(output, "")
    table.insert(output, "# Output")
    table.insert(output, "")
    table.insert(output, "```")
    vim.list_extend(output, executor(block))
    table.insert(output, "```")



    local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    local temp_width = math.floor(vim.o.columns * 0.8)
    local temp_height = math.floor(vim.o.lines * 0.8)
    code_win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      style = "minimal",
      width = temp_width,
      height = temp_height,
      row = math.floor((vim.o.lines - temp_height) / 2),
      col = math.floor((vim.o.columns - temp_width) / 2),
      noautocmd = true,
      border = "rounded",
      zindex = 100,
    })

    vim.bo[buf].filetype = "markdown"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  end)

  -- "q" to quit
  present_keymap("n", "q", function()
    vim.api.nvim_win_close(state.floats.body.win, true)
  end)

  -- Update global config, but save current state for when you quit presentation
  local restore = {
    cmdheight = {
      original = vim.o.cmdheight,
      present = 0
    },
  }

  -- Set the options we want during the presentation
  for option, config in pairs(restore) do
    vim.opt[option] = config.present
  end

  -- If running in a tmux session, disable the status bar
  vim.fn.system('tmux set-option status off')

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = state.floats.body.buf,
    callback = function()
      for option, config in pairs(restore) do
        vim.opt[option] = config.original
      end
      -- Reset tmux status bar if in tmux
      vim.fn.system('tmux set-option status on')

      -- Clean up header window
      foreach_float(function(_, float)
        vim.api.nvim_win_close(float.win, true)
      end)
    end
  })

  -- Update window sizing on resize actions
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("present-resized", {}),
    callback = function()
      -- don't do anything if current windows aren't valid
      if not vim.api.nvim_win_is_valid(state.floats.body.win) or state.floats.body.win == nil then
        return
      end

      -- update the floating window config on resize
      local updated = create_window_configurations()
      foreach_float(function(name, _)
        vim.api.nvim_win_set_config(state.floats[name].win, updated[name])
      end)

      -- helps update the title position
      set_slide_content(state.current_slide)
    end,
  })

  -- Set initial slide content
  set_slide_content(state.current_slide)
end

-- M.start_presentation({
--   bufnr = 8
-- })

return M
