# dotfiles

## Todoist
* add update_from_upstream.sh
* fix permission problem

## Useage
change the "$git_name" and "$git_email" in install.sh

```
cd ~
mkdir Programfile
cd ./Programfile
git clone https://github.com/WildfootW/dotfiles.git
cd ./dotfiles
./install.sh
git remote set-url origin git@github.com:WildfootW/dotfiles.git
```

### required
[Powerline fonts](https://github.com/powerline/fonts)
for the correct theme th display in terminal
* git
* zsh
* vim
* tmux

### theme
#### theme
* Nordic-darker
    `git clone -b darker --single-branch  https://github.com/EliverLara/Nordic.git Nordic-darker`

#### icon
* Zafiro-Icons-Blue


## Vim plugin
### manager
1. [VundleVim](https://github.com/VundleVim/Vundle.vim)
### auto pair
2. [Auto pairs](https://github.com/vim-scripts/Auto-Pairs)
### vim command tools
3. [vim-surround](https://github.com/tpope/vim-surround)
### airline
4. [vim-airline](https://github.com/vim-airline/vim-airline)
5. [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
### file tree
6. [nerdtree](https://github.com/scrooloose/nerdtree)
7. [vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)
### code and files fuzzy finder
8. [ctrlp](https://github.com/kien/ctrlp.vim)
### git
9. [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
### move around
10. [vim-easymotion](https://github.com/easymotion/vim-easymotion)
### tab manage
11. [tabline](https://github.com/mkitt/tabline.vim)
### color scheme
12. [fisa](https://github.com/fisadev/fisa-vim-colorscheme)
13. [vim-colorschemes](https://github.com/flazz/vim-colorschemes)

## tmux
[oh-my-tmux](https://github.com/gpakosz/.tmux)

# Troubleshooting
## Manually install ssh key of GitHub
```
eval $(ssh-agent)
ssh-add ~/.ssh/GitHub
```
