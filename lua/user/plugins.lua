require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This plugin is disabled in your original file, keeping it that way.
  -- {
  --   'max397574/better-escape.nvim',
  --   event = 'InsertEnter',
  --   config = function()
  --     require('better_escape').setup {
  --       mapping = { 'jk', 'kj' }, -- A mapping to escape from insert mode
  --       timeout = vim.o.timeoutlen, -- Timeout to escape from insert mode
  --       clear_empty_lines = false, -- Remove potentially empty lines after escaping
  --       keys = '<Esc>', -- Keys used for escaping, if it is a function will use the result everytime
  --     }
  --   end,
  -- },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
    end,
  },

  -- Adds git related signs to the gutter, as well as utilities for ggmanaging changes
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Collection of diagnostic plugins
    'chrisgrieser/nvim-dr-lsp',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true, -- default config
  },

  -- Fuzzy Finder (Celescope)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' }, -- Optional for icons
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'python',
        'query',
        'regex',
        'rust',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- Set up folding after treesitter is configured
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "python", "javascript", "typescript", "tsx",
          "rust", "c", "html", "json", "yaml", "bash"
        },
        callback = function()
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        end,
      })
    end,
  },

  -- Colorscheme
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {} }, -- Loaded early

  -- LSP Zero (for LSP, Mason, cmp)
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true, -- Will be loaded by lsp.lua
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },

      -- Snippets
      { 'L3MON4D3/LuaSnip',                 version = 'v2.*' }, -- Fuzzy finder algorithm which requires local dependencies to be built
      { 'rafamadriz/friendly-snippets' },                       -- Useful snippets
      { 'saadparwaiz1/cmp_luasnip' },                           -- Snipet completion source for nvim-cmp
    },
    config = function()
      -- This is deferred to lsp.lua, which will require('lsp-zero')
      -- and then call its setup functions.
      -- This ensures plugins are loaded before LSP setup is attempted.
    end,
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  -- Commenting
  { 'numToStr/Comment.nvim', opts = {} },

  -- File Explorer
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
      }
      vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
      vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle and find current file' })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight',
          -- Other lualine options from your config...
          component_separators = '',
          section_separators = '',
        },
      }
    end,
  },

  -- Indent Blankline
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      -- options from your config
      indent = {
        char = '┊',
        tab_char = '┊',
      },
      scope = { enabled = false },
    },
  },

  -- Dashboard
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('dashboard').setup {
        -- Your dashboard config
        theme = 'doom',
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            -- Add other shortcuts as needed
          },
        },
      }
    end,
  },

  -- Undo Tree
  {
    'mbbill/undotree',
    event = 'BufReadPre', -- Or on a keymap
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndo Tree' })
    end,
  },
  {
    'onsails/lspkind.nvim',
    event = 'VimEnter', -- Or 'VeryLazy'
    -- No specific config needed unless you want to customize lspkind itself
  },

  -- Add your other plugins here, following the same structure
  -- For example, if you had a formatter plugin like null-ls or conform:
  -- {
  --   'stevearc/conform.nvim',
  --   opts = {
  --     formatters_by_ft = {
  --       lua = { 'stylua' },
  --       -- python = { 'isort', 'black' },
  --       -- Add other formatters
  --     },
  --     format_on_save = {
  --       timeout_ms = 500,
  --       lsp_fallback = true,
  --     },
  --   },
  -- },

  -- The following are already present in your init.lua and handled by lsp-zero or other sections:
  -- 'neovim/nvim-lspconfig',
  -- 'hrsh7th/nvim-cmp',
  -- 'hrsh7th/cmp-nvim-lsp',
  -- 'L3MON4D3/LuaSnip',
}, {
  -- lazy.nvim options
  checker = {
    enabled = true,
    notify = false, -- Don't notify on new commits
  },
  change_detection = {
    enabled = true,
    notify = false, -- Don't notify on detected changes
  },
})
