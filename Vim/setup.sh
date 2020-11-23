#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019-2020 WildfootW All rights reserved.
#

files=(vim vimrc)

CurrentUser=$1
HomeDirectory=$2
ScriptLocation=$3  # root folder setup.sh location

function initial()
{
    if [ "$CurrentUser" == "" ] || [ "$HomeDirectory" == "" ] || [ "$ScriptLocation" == "" ]; then
        echo "[Vim Setup] No argument passed"
        exit 1
    fi
    ScriptLocation="$ScriptLocation/Vim"
}

function install_file()
{
    dst="$HomeDirectory/.$1"
    if [ -f $dst ] || [ -d $dst ]; then
        echo "File conflict: $dst"
    else
        src="$ScriptLocation/$1"
        echo "Link $src to $dst"
        ln -s $src $dst
    fi
}

initial

#install files and folders
for file in ${files[@]}; do
    install_file $file
done

#install vim plugins
echo "Install vim plugins"
vim +qall


