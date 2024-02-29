return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      '<leader>xx',
      function()
        require('trouble').toggle()
      end,
      desc = 'Toggle trouble',
    },
    {
      '<leader>xw',
      function()
        require('trouble').toggle 'workspace_diagnostics'
      end,
      desc = 'Toggle trouble workspace diagnostics',
    },
    {
      '<leader>xd',
      function()
        require('trouble').toggle 'document_diagnostics'
      end,
      desc = 'Toggle trouble document diagnostics',
    },
    {
      '<leader>xq',
      function()
        require('trouble').toggle 'quickfix'
      end,
      desc = 'Toggle trouble quickfix list',
    },
    {
      '<leader>xl',
      function()
        require('trouble').toggle 'loclist'
      end,
      desc = 'Toggle trouble loclist',
    },
    {
      '<leader>gR',
      function()
        require('trouble').toggle 'lsp_references'
      end,
      desc = 'Toggle trouble lsp_references',
    },
  },
}
