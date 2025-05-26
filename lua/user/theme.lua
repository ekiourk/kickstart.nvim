vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local name = vim.g.colors_name
    vim.g.current_colorscheme = name
    vim.notify("Colorscheme set to: '" .. vim.g.colors_name .. "'", vim.log.levels.WARN)
  end,
})


local ok, tokyonight = pcall(require, "tokyonight")
if not ok then
  vim.notify("tokyonight.nvim is not installed", vim.log.levels.WARN)
  return
end

-- You can add any additional theme-specific configuration here if 'tokyonight.nvim' supports it
-- For example, if 'tokyonight.nvim' has a setup function:
tokyonight.setup({
  style = "storm", -- "storm", "moon", "night", or "day"
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false },
    functions = {},
    variables = {},
  },
})

-- add any fallback themes here
local themes = {
  "kanagawa",
  "tokyonight",
  "habamax"
}

local function try_load_theme(theme_list)
  for _, theme in ipairs(theme_list) do
    local ok, _ = pcall(vim.cmd, 'colorscheme ' .. theme)
    if ok then
      return true
    else
      vim.notify("Colorscheme '" .. theme .. "' not found!", vim.log.levels.WARN)
    end
  end
  vim.notify("No colorscheme could be loaded!", vim.log.levels.ERROR)
  return false
end

try_load_theme(themes)
