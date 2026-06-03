-- Editor options (translated from the old init.vim `set` lines).
local opt = vim.opt

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- UI
opt.number = true
opt.cursorline = true
opt.ruler = true
opt.laststatus = 3        -- global statusline (lualine)
opt.showcmd = true
opt.showmode = false      -- mode is shown by lualine
opt.title = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.list = true
opt.listchars = { tab = ">-", trail = "-" }
opt.fillchars:append({ vert = " " })

-- Wrapping / text
opt.wrap = true
opt.breakindent = true
opt.encoding = "utf-8"

-- Behaviour
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.updatetime = 250

-- Filetype-specific 2-space indent (was autocmds in init.vim)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "xml", "htmldjango", "javascript", "json", "yaml", "lua" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})
