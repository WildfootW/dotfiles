-- deoplete + deoplete-jedi (dead) -> native LSP + blink.cmp.
return {
  -- Completion engine
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = { preset = "default" },
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      completion = { documentation = { auto_show = true } },
    },
  },

  -- LSP servers, installed/managed by mason
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", config = true },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()
      -- mason-lspconfig v2 auto-enables installed servers via vim.lsp.enable,
      -- so we do NOT call lspconfig[server].setup() ourselves (that would
      -- attach each server twice). Capabilities are applied to every server
      -- through the native vim.lsp.config("*", ...) default (Neovim 0.11+).
      -- pyright + bash-language-server are Node-based; setup_toolchains installs
      -- Node via fnm so mason can install them. lua_ls/clangd are standalone.
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "pyright", "bashls" },
      })
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Buffer-local LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local o = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
        end,
      })
    end,
  },
}
