local M = {}

-- List of theme names in order of priority
local themes = {
  "kanagawa",
  "tokyonight",
  "habamax", -- built-in fallback
}

-- Setup configurations per theme (optional)
local function configure_theme(theme)
  if theme == "tokyonight" then
    local ok, tokyonight = pcall(require, "tokyonight")
    if ok then
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
    end
  elseif theme == "kanagawa" then
    local ok, kanagawa = pcall(require, "kanagawa")
    if ok then
      kanagawa.setup({})
    end
  end
end

-- Try to load the first available theme
function M.apply_first_available()
  for _, theme in ipairs(themes) do
    configure_theme(theme)
    local ok = pcall(vim.cmd.colorscheme, theme)
    if ok then
      vim.schedule(function()
        vim.api.nvim_echo({ { "Colorscheme set to: " .. theme, "Normal" } }, false, {})
      end)
      return true
    else
      vim.schedule(function()
        vim.notify("Colorscheme '" .. theme .. "' not found!", vim.log.levels.WARN)
      end)
    end
  end
  vim.schedule(function()
    vim.notify("No colorscheme could be loaded!", vim.log.levels.ERROR)
  end)
  return false
end

-- Manually switch to a given theme
function M.switch_to(theme)
  configure_theme(theme)
  local ok = pcall(vim.cmd.colorscheme, theme)
  if ok then
    vim.schedule(function()
      vim.api.nvim_echo({ { "Switched to theme: " .. theme, "Normal" } }, false, {})
    end)
  else
    vim.schedule(function()
      vim.notify("Theme '" .. theme .. "' failed to load", vim.log.levels.ERROR)
    end)
  end
end

-- Show a picker to select a theme from the list
function M.pick_theme()
  vim.ui.select(themes, { prompt = "Select colorscheme" }, function(choice)
    if choice then
      M.switch_to(choice)
    end
  end)
end

-- Create user command and keymap
vim.api.nvim_create_user_command("PickTheme", M.pick_theme, {})
vim.keymap.set("n", "<leader>ut", M.pick_theme, { desc = "Pick Colorscheme" })

return M
