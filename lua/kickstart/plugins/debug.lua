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
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    { '<F5>',       function() require('dap').continue() end,                                            desc = 'Debug: Start/Continue' },
    { '<F1>',       function() require('dap').step_into() end,                                           desc = 'Debug: Step Into' },
    { '<F2>',       function() require('dap').step_over() end,                                           desc = 'Debug: Step Over' },
    { '<F3>',       function() require('dap').step_out() end,                                            desc = 'Debug: Step Out' },
    { '<leader>b',  function() require('dap').toggle_breakpoint() end,                                   desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B',  function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
    { '<F7>',       function() require('dapui').toggle() end,                                            desc = 'Debug: See last session result.' },
    { '<leader>dr', function() require('dap').repl.open() end,                                           desc = 'Debug: Open REPL' },
    { '<leader>dl', function() require('dap').run_last() end,                                            desc = 'Debug: Run Last' },
    { '<leader>dt', function() require('dap').terminate() end,                                           desc = 'Debug: Terminate' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = {
        'delve',     -- Go
        'debugpy',   -- Python 🐍
        'node2',     -- Node.js/JavaScript
        'codelldb',  -- Rust/C/C++
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
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            'breakpoints',
            'stacks',
            'watches',
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            'repl',
            'console',
          },
          size = 0.25,
          position = 'bottom',
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
    local function setup_python_dap()
      local dap_python = require('dap-python')

      -- Try multiple Python paths
      local python_paths = {
        vim.g.python3_host_prog,
        vim.fn.exepath('python3'),
        vim.fn.exepath('python'),
        '/usr/bin/python3',
        '/usr/local/bin/python3',
      }

      local python_path = nil
      for _, path in ipairs(python_paths) do
        if path and path ~= '' and vim.fn.executable(path) == 1 then
          python_path = path
          break
        end
      end

      if not python_path then
        vim.notify('Python executable not found for debugging', vim.log.levels.WARN)
        return
      end

      dap_python.setup(python_path)

      -- Test configurations
      table.insert(dap.configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = python_path,
      })

      table.insert(dap.configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'Launch module',
        module = function()
          return vim.fn.input('Module name: ')
        end,
        pythonPath = python_path,
      })
    end

    -- Set up Python debugging
    pcall(setup_python_dap)

    -- Virtual text setup (if available)
    pcall(function()
      require('nvim-dap-virtual-text').setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })
    end)

    -- Custom keymaps for Python debugging
    vim.keymap.set('n', '<leader>dm', function()
      if require('dap-python') then
        require('dap-python').test_method()
      end
    end, { desc = 'Debug: Python test method' })

    vim.keymap.set('n', '<leader>dc', function()
      if require('dap-python') then
        require('dap-python').test_class()
      end
    end, { desc = 'Debug: Python test class' })

    -- Enhanced diagnostic configuration
    vim.fn.sign_define('DapBreakpoint', {
      text = '🔴',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint'
    })

    vim.fn.sign_define('DapBreakpointCondition', {
      text = '🟡',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint'
    })

    vim.fn.sign_define('DapStopped', {
      text = '▶️',
      texthl = 'DapStopped',
      linehl = 'DapStopped',
      numhl = 'DapStopped'
    })
  end,
}
