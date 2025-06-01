return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = "VenvSelect", -- lazy-load on command
    opts = {
      name = ".venv",
      search_venv_managers = {
        {
          name = "virtualenvwrapper",
          paths = { vim.fn.expand("$WORKON_HOME") },
        },
      },
      auto_refresh = true,
      auto_activate = false,
    },
  }
}
