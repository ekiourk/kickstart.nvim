---@diagnostic disable: undefined-global
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Edit Neovim configuration easily
vim.keymap.set('n', '<leader>vc', function()
  -- Determine the correct config directory based on environment
  local config_path = vim.fn.stdpath 'config'
  vim.cmd('e ' .. config_path .. '/init.lua')
end, { desc = '[V]im [C]onfig' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without reading the documentation.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
-- See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Custom keymaps from your file
vim.keymap.set('n', '<C-d>', '<C-d>zz') -- Center screen after half-page jump
vim.keymap.set('n', '<C-u>', '<C-u>zz') -- Center screen after half-page jump
vim.keymap.set('n', 'n', 'nzzzv')       -- Center screen after search next
vim.keymap.set('n', 'N', 'Nzzzv')       -- Center screen after search previous

-- Greatest remap ever (for pasting without yanking current selection)
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]]) -- Yank to system clipboard
vim.keymap.set('n', '<leader>Y', [["+Y]])          -- Yank line to system clipboard

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]]) -- Delete to black hole register

vim.keymap.set('i', '<C-c>', '<Esc>')              -- Escape from insert mode with Ctrl+C (common, but can conflict)

vim.keymap.set('n', 'Q', '<nop>')                  -- Disable Q for Ex mode

vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, { desc = '[F]ormat [M]ason (LSP)' })

vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')                                         -- Quickfix list navigation
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')                                         -- Quickfix list navigation
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')                                     -- Location list navigation
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')                                     -- Location list navigation

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Substitute word under cursor

vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make current file executable' })
