-- lua/user/lsp.lua

local status_ok, lsp_zero = pcall(require, 'lsp-zero')
if not status_ok then
  vim.notify("lsp-zero not found, LSP setup will be skipped.", vim.log.levels.WARN)
  return
end

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })

  -- Additional keymaps from your init.lua (if not covered by lsp_zero.default_keymaps)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences') -- Using Telescope for references
  map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Format on save if client supports it (or use a dedicated formatter plugin)
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format { async = false, bufnr = bufnr } end, -- Consider { async = true } for non-blocking
      desc = 'Format file before saving',
    })
  end
end)

-- Mason setup
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    -- Your list of LSPs:
    'ts_ls',
    'eslint',
    'lua_ls',
    'marksman', -- For markdown
    'pyright',
    'bashls',
    'jsonls',
    'yamlls',
    'rust_analyzer',
    -- Add any other LSPs you want managed by Mason
  },
  handlers = {
    lsp_zero.default_setup, -- Use lsp-zero's default handler for most servers

    lua_ls = function()
      -- Configure lua_ls specific settings here
      local lspconfig = require('lspconfig')
      -- Use lsp_zero.nvim_lua_ls() to get the base config and merge your settings
      local lua_ls_opts = lsp_zero.nvim_lua_ls()
      lspconfig.lua_ls.setup(vim.tbl_deep_extend('force', lua_ls_opts, {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false, -- Or true if you want to check third-party libraries
            },
            telemetry = { enable = false },
            -- Add other lua_ls specific settings here if needed
          },
        },
      }))
    end,
  },
})

-- Configure nvim-cmp
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action() -- Get cmp actions from lsp-zero

cmp.setup({
  -- Your nvim-cmp setup from init.lua
  completion = {
    -- completeopt = 'menu,menuone,noinsert', -- This is often default or handled well by lsp-zero
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    -- Using cmp_action for Tab/S-Tab navigation with snippets
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    -- Using cmp's own functions for next/prev item, or lsp-zero's actions if preferred
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    -- Note: Your original config had <Down> and <Up> mapped. These often conflict with snippet navigation.
    -- Consider if you still need them or if Tab/S-Tab and C-n/C-p are sufficient.
    -- ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    -- ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = lsp_zero.cmp_format({
    -- Recommended settings from lsp-zero docs for better UI
    fields = { 'abbr', 'kind', 'menu' },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"
      return kind
    end,
  }),
})

-- REMOVED: lsp_zero.setup_nvim_cmp() as it's no longer needed.
-- lsp-zero now integrates with nvim-cmp more directly through the settings above.

-- Configure diagnostic signs using the new API
vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics inline (can be true, false, or a table for more control)
  signs = {
    active = true,     -- This will use the default signs, or you can define them below
    -- Define custom signs if you prefer over the defaults
    -- To see Neovim's defaults, you might not need to specify text/texthl here unless overriding.
    -- Check :help diagnostic-signs after this setup.
    -- The 'vim.fn.sign_define' method is deprecated.
    -- Instead, custom signs are often handled by themes or plugins like 'nvim-web-devicons' for kinds.
    -- If you still want to customize them directly here:
    -- (Note: lspkind usually provides better icons for 'kind' in completion and can also influence diagnostics)
    text = {
      [vim.diagnostic.severity.ERROR] = '', -- Error
      [vim.diagnostic.severity.WARN] = '', -- Warning
      [vim.diagnostic.severity.INFO] = '', -- Info
      [vim.diagnostic.severity.HINT] = '', -- Hint
    },
    -- texthl = { -- Optional: define highlight groups if needed
    --   [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
    --   [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
    --   [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    --   [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    -- },
    -- numhl = { -- Optional: highlight for the number column
    --   [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
    -- },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {            -- Configure the appearance of the diagnostic float window
    source = "always", -- Or "if_many"
    border = "rounded",
    focusable = false,
    style = "minimal",
  }
})

-- Optional: Set highlight groups for diagnostic signs if not handled by your theme
vim.cmd [[
  highlight DiagnosticError guifg=#FF0000 guibg=NONE gui=NONE
  highlight DiagnosticWarn guifg=#FFA500 guibg=NONE gui=NONE
  highlight DiagnosticInfo guifg=#00FFFF guibg=NONE gui=NONE
  highlight DiagnosticHint guifg=#00FF00 guibg=NONE gui=NONE
]]
