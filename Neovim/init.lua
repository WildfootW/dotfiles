-- WildfootW's Neovim config (Lua).
-- Migrated from the old vimscript init.vim (deoplete/airline/nerdtree era) to
-- the modern Lua stack: lazy.nvim + treesitter + native LSP + blink.cmp.
-- Linked to ~/.config/nvim by maintenance.sh.

-- Leader must be set before lazy.nvim loads plugin mappings.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.lazy")
require("config.keymaps")
