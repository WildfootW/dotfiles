#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019-2020 WildfootW All rights reserved.
#

files=(zshrc)

CurrentUser=$1
HomeDirectory=$2
ScriptLocation=$3  # root folder setup.sh location

function initial()
{
    if [ "$CurrentUser" == "" ] || [ "$HomeDirectory" == "" ] || [ "$ScriptLocation" == "" ]; then
        echo "[Zshell Setup] No argument passed"
        exit 1
    fi
    ScriptLocation="$ScriptLocation/Zshell"
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

# clone some custom plugin
git clone https://github.com/zsh-users/zsh-autosuggestions $ScriptLocation/ohmyzsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ScriptLocation/ohmyzsh/custom/plugins/zsh-syntax-highlighting

#switch to zsh
echo "change default shell to zsh"
chsh -s /bin/zsh $CurrentUser

