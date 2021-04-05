#!/usr/bin/env bash

CurrentUser=$1
HomeDirectory=$2
ScriptLocation=$3

function initial()
{
    if [ "$CurrentUser" == "" ] || [ "$HomeDirectory" == "" ] || [ "$ScriptLocation" == "" ]; then
        echo "[Neovim Setup] No argument passed"
        exit 1
    fi
    ScriptLocation="$ScriptLocation/Neovim"
}

function install_font()
{
    # (Optional but recommended) Install a nerd font for icons and a beautiful airline bar (https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts) (I'll be using Iosevka for Powerline)
    echo "[*] Downloading patch font into ~/.local/share/fonts ..."
    curl -fLo $HomeDirectory/.fonts/Iosevka\ Term\ Nerd\ Font\ Complete.ttf --create-dirs https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete.ttf
}

function install()
{
    # Make config directory for Neovim's init.vim
    echo '[*] Preparing Neovim config directory ...'
    mkdir -p $HomeDirectory/.config/nvim

    # Install nvim (and its dependencies: pip3, git), Python 3 and ctags (for tagbar)
#    echo '[*] App installing Neovim and its dependencies (Python 3 and git), and dependencies for tagbar (exuberant-ctags) ...'
#    sudo apt update
#    sudo apt install neovim python3 python3-pip python3-venv git curl exuberant-ctags -y

    # Install virtualenv to containerize dependencies
    echo '[*] Pip installing venv to containerize Neovim dependencies (instead of installing them onto your system) ...'
    python3 -m venv $HomeDirectory/.config/nvim/venv

    # Install pip modules for Neovim within the virtual environment created
    echo '[*] Activating virtualenv and pip installing Neovim (for Python plugin support), libraries for async autocompletion support (jedi, psutil, setproctitle), and library for pep8-style formatting (yapf) ...'
    source $HomeDirectory/.config/nvim/venv/bin/activate
    python3 -m pip install pynvim jedi psutil setproctitle yapf doq # run `pip uninstall neovim pynvim` if still using old neovim module
    deactivate

    # Install vim-plug plugin manager
    echo '[*] Downloading vim-plug, the best minimalistic vim plugin manager ...'
    curl -fLo $HomeDirectory/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#    # Enter Neovim and install plugins using a temporary init.vim, which avoids warnings about missing colorschemes, functions, etc
#    echo -e '[*] Running :PlugInstall within nvim ...'
#    sed '/call plug#end/q' init.vim > $HomeDirectory/.config/nvim/init.vim
#    nvim -c ':PlugInstall' -c ':UpdateRemotePlugins' -c ':qall'
#    rm $HomeDirectory/.config/nvim/init.vim

    # Copy init.vim in current working directory to nvim's config location ...
    echo '[*] Linking init.vim -> ~/.config/nvim/init.vim'
    ln -s $ScriptLocation/init.vim $HomeDirectory/.config/nvim/
}

initial

install
