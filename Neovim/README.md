# Neovim config (Lua)

Modern Lua setup built on **lazy.nvim**. Migrated from the old vimscript
`init.vim` (deoplete / airline / nerdtree era), which is gone.

```
init.lua                  # leader = "," ; loads config.*
lua/config/options.lua    # editor options
lua/config/keymaps.lua    # key mappings + small helpers
lua/config/lazy.lua       # lazy.nvim bootstrap
lua/plugins/*.lua         # plugin specs (one file per concern)
```

## Requirements

Installed by the repo's `maintenance.sh` (option 1 / 5 / 6):

- Neovim ≥ 0.11 (installed from the official release tarball into `~/.local`)
- `git`, `curl`, a C compiler (treesitter), **universal-ctags** (aerial fallback)
- A **Nerd Font** for icons
- Node (`fnm`) / Python (`uv`) for LSP servers that need them — mason installs the rest

## Plugin map (old → new)

| Old (init.vim) | New |
|----------------|-----|
| vim-plug | lazy.nvim |
| deoplete + deoplete-jedi | native LSP (mason + lspconfig) + blink.cmp |
| nerdtree | neo-tree |
| tagbar | aerial.nvim |
| fzf.vim | telescope.nvim |
| airline | lualine.nvim |
| gitgutter | gitsigns.nvim |
| easymotion | flash.nvim |
| nerdcommenter | built-in `gc` (Neovim ≥ 0.10) |
| auto-pairs | nvim-autopairs |
| ultisnips + vim-snippets | LuaSnip + friendly-snippets |
| vim-pydocstring (doq) | neogen |
| goyo / limelight | zen-mode / twilight |
| Colorizer | nvim-colorizer.lua |
| vim-easy-align | mini.align |
| indentLine | indent-blankline |
| copilot.vim | copilot.lua |
| vim-polyglot | nvim-treesitter |
| dracula/vim | tokyonight.nvim (shared theme with starship/tmux) |
| vim-template | vim-template (kept; uses `~/dotfiles/Templates`) |

## Updating plugins

```vim
:Lazy sync      " install/update/clean to match the lockfile
:Lazy           " open the UI
:Mason          " manage LSP servers
:checkhealth    " diagnose
```

## Key mappings (leader = `,`)

| Key | Action |
|-----|--------|
| `,q` | File tree (neo-tree) |
| `,w` | Symbol outline (aerial) |
| `\`  | Toggle tree + outline |
| `,f` | Find files (telescope) |
| `,/` | Live grep |
| `,b` | Buffers |
| `,ee` | Colorscheme picker |
| `,e1` | Dracula |
| `,g` | Zen mode |
| `,l` | Twilight |
| `,k` | Toggle hex colors |
| `,d` | Generate docstring (neogen) |
| `,x` | Format buffer (LSP) |
| `,t` | Trim trailing whitespace |
| `,r` | Reload config |
| `,,` | Clear search highlight |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `s` / `S` | Flash jump / treesitter |
| `ga` / `gA` | Align (mini.align) |
| `gc` | Comment (built-in) |
| `gd` `gr` `K` `,rn` `,ca` | LSP: definition / references / hover / rename / code action |
| `<C-l>` | Accept Copilot suggestion |
