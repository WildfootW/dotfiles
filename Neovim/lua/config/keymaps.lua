-- Key mappings. Leader is "," (set in init.lua). These preserve the muscle
-- memory from the old init.vim, pointed at the new plugins.
local map = vim.keymap.set

-- File tree (NERDTree -> neo-tree) and symbol outline (tagbar -> aerial)
map("n", "<leader>q", "<cmd>Neotree toggle<cr>", { desc = "File tree" })
map("n", "<leader>w", "<cmd>AerialToggle<cr>", { desc = "Symbol outline" })
map("n", "\\", "<cmd>Neotree toggle<cr><cmd>AerialToggle<cr>", { desc = "Tree + outline" })

-- Fuzzy finding (fzf.vim -> telescope)
map("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>ee", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme picker" })

-- Colors / focus modes
map("n", "<leader>e1", "<cmd>colorscheme tokyonight<cr>", { desc = "Tokyo Night" })
map("n", "<leader>g", "<cmd>ZenMode<cr>", { desc = "Zen mode (Goyo)" })
map({ "n", "x" }, "<leader>l", "<cmd>Twilight<cr>", { desc = "Twilight (Limelight)" })
map("n", "<leader>k", "<cmd>ColorizerToggle<cr>", { desc = "Toggle hex colors" })

-- Docstring (vim-pydocstring -> neogen)
map("n", "<leader>d", "<cmd>Neogen<cr>", { desc = "Generate docstring" })

-- Format current buffer via LSP (was python yapf)
map("n", "<leader>x", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })

-- Trim trailing whitespace (was a custom function)
local function trim_whitespace()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end
map("n", "<leader>t", trim_whitespace, { desc = "Trim trailing whitespace" })

-- Reload config / clear search highlight
map("n", "<leader>r", "<cmd>source $MYVIMRC<cr>", { desc = "Reload config" })
map("n", "<leader><leader>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Buffer navigation
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Terminal: escape to normal mode
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

-- Save a file you opened without sudo
vim.cmd("cnoreabbrev w!! w !sudo tee > /dev/null %")
