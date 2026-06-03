-- Pairs, snippets, docstrings, alignment, file templates.
-- (Commenting is built into Neovim >= 0.10 via `gc`, so no plugin needed.)
return {
  -- auto-pairs -> nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- ultisnips + vim-snippets -> LuaSnip + friendly-snippets
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- vim-pydocstring(doq) -> neogen (pure Lua, no python venv)
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
  },

  -- vim-easy-align -> mini.align (ga / gA)
  {
    "echasnovski/mini.align",
    version = false,
    keys = {
      { "ga", mode = { "n", "x" } },
      { "gA", mode = { "n", "x" } },
    },
    config = function() require("mini.align").setup() end,
  },

  -- File templates: keep vim-template (still works, uses your Templates/ dir)
  {
    "aperezdc/vim-template",
    event = "VeryLazy",
    init = function()
      vim.g.templates_directory = { "~/dotfiles/Templates" }
      vim.g.email = "wildfootw@wildfoo.tw"
    end,
  },
}
