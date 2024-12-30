return {
  dir = vim.fn.stdpath("config") .. "/lua/config/present",
  config = function()
    vim.api.nvim_create_user_command("PresentStart", function()
      require("config.present.present").start_presentation()
    end, {})
  end,
}
