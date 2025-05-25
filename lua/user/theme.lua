-- Set colorscheme to tokyonight
-- This will be loaded by lazy.nvim, but we apply it here.
local status, _ = pcall(vim.cmd, 'colorscheme tokyonight')
if not status then
  vim.notify('Colorscheme tokyonight not found!', vim.log.levels.WARN)
  -- Fallback to a default theme if tokyonight is not found
  -- vim.cmd.colorscheme "habamax"
  return
end

-- You can add any additional theme-specific configuration here if 'tokyonight.nvim' supports it
-- For example, if 'tokyonight.nvim' has a setup function:
-- require('tokyonight').setup({
--   style = "night", -- or "storm", "day"
--   -- other options
-- })
