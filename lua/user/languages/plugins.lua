return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = "VenvSelect", -- lazy-load on command
    opts = {
      name = ".venv",
      search_venv_managers = {
        {
          name = "virtualenvwrapper",
          paths = { vim.fn.expand("$WORKON_HOME") },
        },
      },
      auto_refresh = true,
      auto_activate = false,
    },
    keys = {
      { '<leader>vs', '<cmd>VenvSelect<cr>',       desc = 'Select Python Venv' },
      { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = 'Select Cached Venv' },
    },
  },
  -- Better Python indentation
  {
    'Vimjas/vim-python-pep8-indent',
    ft = 'python',
  },

  -- Python docstring generator
  {
    'heavenshell/vim-pydocstring',
    ft = 'python',
    build = 'make install',
    config = function()
      vim.g.pydocstring_formatter = 'google' -- or 'numpy', 'sphinx'
    end,
  },
}
