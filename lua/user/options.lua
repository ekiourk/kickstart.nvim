-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise mapping will not work)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See `:help vim.o`
--[[Defaults (commented out):
vim.o.autoread = true -- Autoread when files change on disk
vim.o.autowrite = true -- Enable auto write
vim.o.clipboard = 'unnamedplus' -- Sync with system clipboard
vim.o.cmdheight = 1 --Cmd height
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.conceallevel = 3 -- Hide *markup* symbols
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.fillchars = { eob = ' ' } --Don't show tilde on blank lines
vim.o.formatoptions = 'jcroqlnt' -- tcqj
vim.o.grepformat = '%f:%l:%c:%m'
vim.o.grepprg = 'rg --vimgrep'
vim.o.hidden = true -- Enable background buffers
vim.o.ignorecase = true -- Ignore case
vim.o.inccommand = 'nosplit' -- preview incremental substitute
vim.o.joinspaces = false -- No double spaces with join after sentence
vim.o.list = true -- Show some invisible characters (tabs...
vim.o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.number = true -- Print line number
vim.o.pumblend = 10 -- Popup blend
vim.o.pumheight = 10 -- Maximum number of entries in a popup
vim.o.relativenumber = true -- Relative line numbers
vim.o.scrolloff = 4 -- Lines of context
vim.o.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 2 -- Size of an indent
vim.o.shortmess = vim.o.shortmess .. 'cse' -- Remove redundant messages
vim.o.showmode = false -- Don't show mode since it's in status line
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.smartindent = true -- Insert indents automatically
vim.o.spell = false
vim.o.spelllang = { 'en' }
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right current
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.o.termguicolors = true -- True color support
vim.o.timeoutlen = 300 -- Lower than default (1000) for which-key
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200 -- Save swap file and trigger CursorHold
vim.o.wildmode = 'longest:full,full' -- Command-line completion mode
vim.o.winminwidth = 5 -- Minimum window width
vim.o.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
]]

-- Simplified options from your init.lua:
vim.opt.autoread = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.cursorline = true
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.formatoptions = 'jcroqlnt'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit' -- Preview incremental substitute
vim.opt.list = true -- Show some invisible characters
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '␣' } -- Customize invisible characters
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true
vim.opt.scrolloff = 8  -- Lines of context
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2     -- Size of an indent
vim.opt.showmode = false   -- Don't show mode since it's in status line
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes' -- Always show the signcolumn
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.wrap = false -- Disable line wrap

-- Setting for which-key (though it might be better placed in the plugin's config)
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Persistent undo
-- vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- Original was commented
-- You might want to use stdpath for this:
local undodir = vim.fn.stdpath 'data' .. '/undodir'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Folding options (from your original file)
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldlevel = 99 -- Start with all folds open
