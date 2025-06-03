---@diagnostic disable: undefined-global
-- LSP Configuration with lsp-zero, mason, and nvim-cmp

-- Load lsp-zero safely
local status_ok, lsp_zero = pcall(require, 'lsp-zero')
if not status_ok then
  vim.notify("lsp-zero not found, LSP setup will be skipped.", vim.log.levels.WARN)
  return
end

-- Set log level for LSP (reduce noise)
vim.lsp.set_log_level("warn")

-- LSP on_attach handler
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })

  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  -- Enhanced keymaps
  map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Additional useful mappings
  map('<leader>f', function() vim.lsp.buf.format { async = true } end, '[F]ormat Document')
  map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  map('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Format on save (with better logic)
  if client.supports_method('textDocument/formatting') then
    local augroup = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          async = false,
          bufnr = bufnr,
          filter = function(format_client)
            -- Only format with the current client
            return format_client.id == client.id
          end
        })
      end,
      desc = 'Format file before saving',
    })
  end

  -- Highlight symbol under cursor
  if client.supports_method('textDocument/documentHighlight') then
    local highlight_augroup = vim.api.nvim_create_augroup('LspDocumentHighlight.' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end)

-- Enhanced LSP handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    width = 60,
    max_width = 80,
    max_height = 20,
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
    width = 60,
  }
)

-- Mason setup
require('mason').setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require('mason-lspconfig').setup({
  ensure_installed = {
    -- Language servers
    'lua_ls',        -- Lua
    'pyright',       -- Python
    'ts_ls',         -- TypeScript/JavaScript
    'eslint',        -- ESLint
    'rust_analyzer', -- Rust
    'bashls',        -- Bash
    'jsonls',        -- JSON
    'yamlls',        -- YAML
    'marksman',      -- Markdown
    'html',          -- HTML
    'cssls',         -- CSS
    'tailwindcss',   -- Tailwind CSS (if you use it)
  },
  handlers = {
    -- Default handler
    function(server_name)
      require('lsp-zero').default_setup(server_name)
    end,

    -- Lua language server
    ["lua_ls"] = function()
      require('lspconfig').lua_ls.setup(require('lsp-zero').nvim_lua_ls())
    end,

    -- Python language server
    ["pyright"] = function()
      require('lspconfig').pyright.setup({
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic", -- or "strict"
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            }
          }
        }
      })
    end,

    -- TypeScript/JavaScript
    ["ts_ls"] = function()
      require('lspconfig').ts_ls.setup({
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          }
        }
      })
    end,

    -- JSON language server
    ["jsonls"] = function()
      require('lspconfig').jsonls.setup({
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
})

-- Enhanced nvim-cmp setup
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
local lspkind_ok, lspkind = pcall(require, 'lspkind')

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    }),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip',  priority = 750 },
    { name = 'buffer',   priority = 500 },
    { name = 'path',     priority = 250 },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    }),
    documentation = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    }),
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      if lspkind_ok then
        local kind = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = '...',
        })(entry, vim_item)

        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        return kind
      else
        -- Fallback without lspkind
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end
    end,
  },
  experimental = {
    ghost_text = true,
  },
})

-- Command line completion
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = 'path' } },
    { { name = 'cmdline' } }
  )
})

-- Enhanced diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = "if_many",
    spacing = 2,
  },
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
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
    header = "",
    prefix = "",
    suffix = "",
    format = function(diagnostic)
      return string.format("%s (%s) [%s]",
        diagnostic.message,
        diagnostic.source,
        diagnostic.code or diagnostic.user_data.lsp.code
      )
    end,
  }
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Custom highlight for diagnostics
vim.cmd [[
  highlight DiagnosticError guifg=#FF6B6B guibg=NONE gui=NONE
  highlight DiagnosticWarn guifg=#FFD93D guibg=NONE gui=NONE
  highlight DiagnosticInfo guifg=#6BCF7F guibg=NONE gui=NONE
  highlight DiagnosticHint guifg=#4D9DE0 guibg=NONE gui=NONE

  highlight DiagnosticVirtualTextError guifg=#FF6B6B guibg=NONE gui=italic
  highlight DiagnosticVirtualTextWarn guifg=#FFD93D guibg=NONE gui=italic
  highlight DiagnosticVirtualTextInfo guifg=#6BCF7F guibg=NONE gui=italic
  highlight DiagnosticVirtualTextHint guifg=#4D9DE0 guibg=NONE gui=italic
]]
