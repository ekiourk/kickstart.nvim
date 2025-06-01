-- LSP Configuration with lsp-zero, mason, and nvim-cmp

-- Load lsp-zero safely
local status_ok, lsp_zero = pcall(require, 'lsp-zero')
if not status_ok then
  vim.notify("lsp-zero not found, LSP setup will be skipped.", vim.log.levels.WARN)
  return
end

-- LSP on_attach handler
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })

  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  -- Keymaps
  map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Format on save
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format { async = false, bufnr = bufnr } end,
      desc = 'Format file before saving',
    })
  end
end)

-- Mason setup
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    -- Update this list based on what Mason expects
    'ts_ls',
    'eslint',
    'lua_ls',
    'marksman',
    'pyright',
    'bashls',
    'jsonls',
    'yamlls',
    'rust_analyzer',
  },
  handlers = {
    function(server_name)
      require('lsp-zero').default_setup(server_name)
    end,
    ["lua_ls"] = function()
      require('lspconfig').lua_ls.setup(require('lsp-zero').nvim_lua_ls())
    end,

  },
})

-- nvim-cmp setup
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  completion = {},
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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

-- Diagnostic signs and display config
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = "always",
    border = "rounded",
    focusable = false,
    style = "minimal",
  }
})

-- Optional: custom highlight for diagnostics
vim.cmd [[
  highlight DiagnosticError guifg=#FF0000 guibg=NONE gui=NONE
  highlight DiagnosticWarn guifg=#FFA500 guibg=NONE gui=NONE
  highlight DiagnosticInfo guifg=#00FFFF guibg=NONE gui=NONE
  highlight DiagnosticHint guifg=#00FF00 guibg=NONE gui=NONE
]]
