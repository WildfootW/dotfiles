#!/bin/bash

files='vim vimrc zshrc tmux.conf'

function abspath() {
    pushd . > /dev/null
    if [ -d "$1"  ]; then
        cd "$1"; dirs -l +0
    else
        cd "`dirname \"$1\"`"
        cur_dir=`dirs -l +0`
        if [ "$cur_dir" == "/"  ]; then
            echo "$cur_dir`basename \"$1\"`"
        else
            echo "$cur_dir/`basename \"$1\"`"
        fi
    fi
    popd > /dev/null
}

function check_git() {
    if [ -x "`which git`" ]; then
        echo "You already have git. :D"
    else
        echo "You need git to do this. :("
        exit 1
    fi
}

function check_zsh() {
    if [ -x "`which zsh`" ]; then
        echo "You already have zsh. :D"
        echo "Now we switch to zsh!!"
        chsh -s /bin/zsh
    else
        echo "You may need zsh..."
    fi
}

function check_ohmyzsh() {
    if [ -d ~/.oh-my-zsh -o -d oh-my-zsh ]; then
        echo "You already have oh-my-zsh. Good!"
    else
        echo "Seems that you don't have oh-my-zsh."
        echo "But that's OK, let clone one."
        check_git
        git submodule init
        git submodule update
    fi
}

function install_file() {
    dst=~/.$1
    if [ -f $dst ] || [ -d $dst ]; then
        echo "File conflict: $dst"
    else
        src="`abspath $1`"
        link "$src" "$dst"
    fi
}

function link() {
    echo "Link '$1' to '$2'"
    ln -s "$1" "$2"
}

function install_vim_plugin() {
    echo "Install vim plugins"
    vim +qall
}

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |       WildfootW's dotfile install script       | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\______________________________________________\\|"
echo ""
echo "copy from inndy, thank you Inndy!"
echo "fork from azdkj532, thank you Squirrel!"
check_ohmyzsh

for file in `echo $files | tr ' ' '\n'`; do
    install_file $file
done

install_vim_plugin
check_zsh

