return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    -- Optional: add dap-python helper
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    { '<F5>',      function() require('dap').continue() end,                                            desc = 'Debug: Start/Continue' },
    { '<F1>',      function() require('dap').step_into() end,                                           desc = 'Debug: Step Into' },
    { '<F2>',      function() require('dap').step_over() end,                                           desc = 'Debug: Step Over' },
    { '<F3>',      function() require('dap').step_out() end,                                            desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end,                                   desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
    { '<F7>',      function() require('dapui').toggle() end,                                            desc = 'Debug: See last session result.' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = {
        'delve',     -- Go
        'debugpy',   -- Python 🐍
      },
      handlers = {}, -- Optional custom handlers per language
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸', play = '▶', step_into = '⏎', step_over = '⏭',
          step_out = '⏮', step_back = 'b', run_last = '▶▶',
          terminate = '⏹', disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Go DAP setup
    require('dap-go').setup {
      delve = { detached = vim.fn.has 'win32' == 0 },
    }

    -- Python DAP setup
    local dap_python = require('dap-python')

    -- Use your system's Python, or your Neovim Python provider
    local python_path = vim.g.python3_host_prog or vim.fn.exepath('python3')
    dap_python.setup(python_path)

    -- Optional: Enable test method debugging with <leader>dm
    vim.keymap.set('n', '<leader>dm', dap_python.test_method, { desc = 'Debug: Python test method' })
    vim.keymap.set('n', '<leader>dc', dap_python.test_class, { desc = 'Debug: Python test class' })
  end,
}
