local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- [[ Highlight on yank ]] -- Moved to keymaps.lua as it's closely related, but could live here.
-- local highlight_group = augroup('YankHighlight', { clear = true })
-- autocmd('TextYankPost', {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
--   group = highlight_group,
--   pattern = '*',
-- })

-- From your init.lua, if these are still desired:
-- Close certain filetypes with q
-- augroup('FileTypeQuit', { clear = true })
-- autocmd('FileType', {
--   pattern = {
--     'dapui_watches', 'dapui_stacks', 'dapui_scopes', 'dapui_breakpoints', 'dapui_console', -- dap-ui
--     'help', -- help files
--     'lspinfo', -- lsp info
--     'man', -- man pages
--     'notify', -- notify ui
--     'qf', -- quickfix
--     'query', -- query files
--     'spectre_panel', -- spectre panel
--     'startuptime', -- startup time
--     'tsplayground', -- ts playground
--     '', -- terminal
--   },
--   callback = function(event)
--     vim.bo[event.buf].buflisted = false
--     vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
--   end,
--   group = 'FileTypeQuit',
--   desc = 'Close certain filetypes with q',
-- })

-- Wrap and spell check for text filetypes
augroup('WrapAndSpell', { clear = true })
autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = 'WrapAndSpell',
  desc = 'Enable wrap and spell for text filetypes',
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
augroup('AutoCreateDirectories', { clear = true })
autocmd({ 'BufWritePre' }, {
  group = 'AutoCreateDirectories',
  pattern = '*',
  command = "call mkdir(expand('%:p:h'), 'p')",
  desc = 'Auto create directories when saving a file',
})

-- Other custom autocommands can go here.
-- For example, the terminal opening autocommand from Kickstart if you use it:
-- augroup('OpenTerminal', { clear = true })
-- autocmd('TermOpen', {
--   group = 'OpenTerminal',
--   pattern = 'term://*',
--   callback = function()
--     vim.o.buflisted = false
--     vim.wo.signcolumn = 'no'
--   end,
--   desc = "Setup for terminal buffers"
-- })
