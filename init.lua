-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load user configurations
-- It's generally a good idea to load options first
require('user.options')
require('user.keymaps')
-- Load plugins BEFORE the theme, so the theme plugin is available
require('user.plugins')

-- Now this can apply the theme loaded by plugins.lua
require('user.theme').apply_first_available()

require('user.autocommands')

require('user.languages.init')
require('user.system.check_node')
