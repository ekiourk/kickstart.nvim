local function is_node_version_supported(min_version)
  local handle = io.popen("node --version 2>/dev/null")
  if not handle then return false end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    vim.notify("Node.js is not installed (required for Pyright)", vim.log.levels.WARN)
    return false
  end

  local major = result:match("v(%d+)")
  major = tonumber(major)
  if not major then
    vim.notify("Could not determine Node.js version (output: " .. result .. ")", vim.log.levels.WARN)
    return false
  end

  if major < min_version then
    vim.notify("Node.js >= " .. min_version .. " required for Pyright. Found: " .. result, vim.log.levels.ERROR)
    return false
  end

  return true
end

is_node_version_supported(14)
