#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019-2020 WildfootW All rights reserved.
#

CurrentUser=$1
HomeDirectory=$2
ScriptLocation=$3  # root folder setup.sh location

function initial()
{
    if [ "$CurrentUser" == "" ] || [ "$HomeDirectory" == "" ] || [ "$ScriptLocation" == "" ]; then
        echo "[Git Setup] No argument passed"
        exit 1
    fi
    ScriptLocation="$ScriptLocation/Git"
}

git_email="wildfootw@wildfoo.tw"
git_name="WildfootW"

echo "set git environment settings..."
git config --global user.email $git_email
git config --global user.name $git_name
git config --global color.ui true
git config --global core.editor vim 
git config --global alias.co commit
git config --global alias.lg "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
git config --global push.default simple
git config --global pull.rebase false
git config --global core.excludesfile ~/dotfiles/Git/gitignore # global gitignore

