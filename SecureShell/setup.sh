#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019-2020 WildfootW All rights reserved.
#

CurrentUser=$1
HomeDirectory=$2
ScriptLocation=$3  # root folder setup.sh location

git_email="wildfootw@wildfoo.tw"
git_name="WildfootW"

function initial()
{
    if [ "$CurrentUser" == "" ] || [ "$HomeDirectory" == "" ] || [ "$ScriptLocation" == "" ]; then
        echo "[SecureShell Setup] No argument passed"
        exit 1
    fi
    ScriptLocation="$ScriptLocation/SecureShell"
}

function setup_GitHub_SSH_Key()
{
    echo "Setup GitHub SSH Key..."
    if [ -e "$HomeDirectory/.ssh" ]; then
        if [ ! -d "$HomeDirectory/.ssh" ];then
            echo ".ssh exist in HOME directory but not a directory!"
            echo "GitHub SSH Key setup failed!"
            exit 1
        fi
    else
        mkdir "$HomeDirectory/.ssh"
    fi
#    if [ -e "$HomeDirectory/.ssh/GitHub" ]; then
#        echo "$HomeDirectory/.ssh/GitHub exist"
#        echo "GitHub SSH Key setup failed!"
#        exit 1
#    fi

    ssh-keygen -t rsa -C $git_email -f "$HomeDirectory/.ssh/GitHub" -b 2048 -q -N ""
    #-q Silence ssh-keygen -N new_passphrase

    eval $(ssh-agent)
    ssh-add $HomeDirectory/.ssh/GitHub

    echo "Success!! please paste the public key to GitHub."
    echo "+------------------------------------------------+"
    cat $HomeDirectory/.ssh/GitHub.pub
    echo "+------------------------------------------------+"
    echo "After pasted the public key. Use \"ssh -T git@github.com\" to test if setup success."
    echo "If it is not working. Just command \"ssh-add $HomeDirectory/.ssh/GitHub\" manually."
}

initial

# set ssh config file
ln -s $ScriptLocation/ssh-config $HomeDirectory/.ssh/config

# set GitHub SSH Key
setup_GitHub_SSH_Key

