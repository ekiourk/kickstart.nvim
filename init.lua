---@diagnostic disable: undefined-global
-- Bootstrap lazy.nvim plugin manager

-- Enhanced error handling for your init.lua
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify(string.format("Error loading %s: %s", module, result), vim.log.levels.ERROR)
    return nil
  end
  return result
end

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
safe_require('user.options')
safe_require('user.keymaps')
-- Load plugins BEFORE the theme, so the theme plugin is available
safe_require('user.plugins.init')

-- Now this can apply the theme loaded by plugins.lua
safe_require('user.theme').apply_first_available()

safe_require('user.autocommands')

safe_require('user.languages.init')
safe_require('user.system.check_node')


local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  " ███╗   ██╗██╗   ██╗███╗   ███╗",
  " ████╗  ██║██║   ██║████╗ ████║",
  " ██╔██╗ ██║██║   ██║██╔████╔██║",
  " ██║╚██╗██║██║   ██║██║╚██╔╝██║",
  " ██║ ╚████║╚██████╔╝██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝",
  "       [ Neovim Setup Info ]   ",
}

dashboard.section.buttons.val = {
  dashboard.button("SPC f f", "󰈞  Find file", ":Telescope find_files<CR>"),
  dashboard.button("SPC f o", "  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("SPC f w", "󰈬  Live grep", ":Telescope live_grep<CR>"),
  dashboard.button("SPC f s", "  Search sessions", ":Telescope persisted<CR>"),
  dashboard.button("SPC u", "  Update plugins", ":Lazy update<CR>"),
  dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
}

dashboard.section.footer.val = function()
  local stats = require("lazy").stats()
  local loaded = stats.loaded
  local count = stats.count
  local v = vim.version()
  return string.format(
    "⚙  Neovim %d.%d.%d |   %d/%d plugins loaded in %.2fms",
    v.major,
    v.minor,
    v.patch,
    loaded,
    count,
    stats.startuptime
  )
end

require("alpha").setup(dashboard.config)

-- auto-load the last session only if Neovim was opened without a file
if vim.fn.argc() == 0 then
  require('persistence').load()
end
