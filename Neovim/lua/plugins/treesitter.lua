-- vim-polyglot -> treesitter.
-- The old `master` branch is archived and breaks on Neovim 0.12 ("attempt to
-- call method 'range'"). The `main` branch targets current Neovim and uses a
-- different API: install parsers explicitly, start highlighting per buffer.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "bash",
        "python", "c", "cpp", "rust", "go",
        "javascript", "typescript", "html", "css", "json", "yaml",
        "markdown", "markdown_inline",
      })
      -- Enable treesitter highlighting for any buffer whose parser is present.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
