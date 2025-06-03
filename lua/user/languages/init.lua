---@diagnostic disable: undefined-global
-- Try to load system-specific Python config
local python_host_path = vim.fn.stdpath("config") .. "/lua/user/languages/python_host.lua"

local ok, _ = pcall(dofile, python_host_path)
if not ok then
  vim.notify("[languages/init.lua] python_host.lua not found, skipping python3_host_prog setup", vim.log.levels.WARN)
end


require("lspconfig").pyright.setup({
  on_init = function(client)
    local venv = vim.g["VIRTUAL_ENV"]
    local python_path = venv and (venv .. "/bin/python") or nil
    if python_path then
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
        python = { pythonPath = python_path },
      })
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VenvSelectVenvChanged",
  callback = function()
    vim.cmd("LspRestart")
  end,
})
