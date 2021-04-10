# Neovim init.vim
* Fork from Optixal

Normal usage.

![Normal Usage Example](https://user-images.githubusercontent.com/19287477/62753305-b329be80-ba9d-11e9-84a8-8e778a47bd10.png)

Minimal, focussed sessions with Goyo.

![Goyo Minimal Example](https://user-images.githubusercontent.com/19287477/62753311-b6bd4580-ba9d-11e9-936f-6dbadf90af46.png)

Multi-windowed editing with NerdTree and TagBar sidebars.

![Multi-Window Example](https://user-images.githubusercontent.com/19287477/62753315-b8870900-ba9d-11e9-9276-705c3ab76eba.png)

## Install Requirement
```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt install neovim python3 python3-pip python3-venv git curl exuberant-ctags -y
```

## Update

Update plugins (super simple)

```
nvim
:PlugUpdate
```

(Optional) Clean plugins - Deletes unused plugins

```
nvim
:PlugClean
```

(Optional) Check, download and install the latest vim-plug

```
nvim
:PlugUpgrade
```

## Note

### For Non-GUI Users

* Colorschemes may not be rendered
* Changing fonts may be harder (https://unix.stackexchange.com/a/49823), if you do not intend to do customize your font, you should uncomment the devicons plugin within "init.vim" (`" Plug 'ryanoasis/vim-devicons'`)

### Mapped Commands in Normal Mode

Most custom commands expand off my map leader, keeping nvim as vanilla as possible.

* `,` - Map leader, nearly all my custom mappings starts with pressing the comma key
* `,q` - Sidebar filetree viewer (NERDTree)
* `,w` - Sidebar classes, functions, variables list (TagBar)
* `\`  - Toggle both NERDTree and TagBar
* `,ee` - Change colorscheme (with fzf fuzzy finder)
* `,ea` - Change Airline theme
* `,e1` - Color mode: Dracula (Dark)
* `,e2` - Color mode: Seoul256 (Between Dark & Light)
* `,e3` - Color mode: Forgotten (Light)
* `,e4` - Color mode: Zazen (Black & White)
* `,r` - Refresh/source ~/.config/nvim/init.vim
* `,t` - Trim all trailing whitespaces
* `,a` - Auto align variables (vim-easy-align), eg. do `,a=` while your cursor is on a bunch of variables to align their equal signs
* `,d` - Automatically generate Python docstrings while cursor is hovering above a function or class
* `,f` - Fuzzy find a file (fzf)
* `,g` - Toggle Goyo mode (Goyo), super clean and minimalistic viewing mode
* `,h` - Toggle rainbow parentheses highlighting
* `,j` - Set filetype to "journal" which makes the syntax highlighting beautiful when working on regular text files and markdown
* `,k` - Toggle coloring of hex colors
* `,l` - Toggle Limelight mode (Limelight), highlight the lines near cursor only
* `,c<Space>` - Toggle comment for current line (Nerd Commenter)
* `<Alt-r>` - Toggle RGB color picker
* `<Tab>` - Next buffer
* `<Shift-Tab>` - Previous buffer

