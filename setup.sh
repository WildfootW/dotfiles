#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

# Absolute path to this script, z.B. /home/user/Pwngdb/install.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/Pwngdb
ScriptLocation=$(dirname "$SCRIPT")

CurrentUser=$USER
HomeDirectory=$HOME

source ./Misc/check_distribution.sh
echo "your distribution is $distribution $distribution_version"

#softwares=(git zsh vim tmux) # fonts-powerline
subfolders=(Git SecureShell Tmux Neovim Zshell)

function initial()
{
#    if [ "$distribution" == "Ubuntu" ]; then
#        permission=$USER
#        CurrentUser=$SUDO_USER
#        HomeDirectory=$HOME
#    elif [ "$distribution" == "CentOS Linux" ]; then
#        permission=$USER
#        CurrentUser=$SUDO_USER
#        HomeDirectory="/home/$SUDO_USER"
#    elif [ "$distribution" == "Kali GNU/Linux" ]; then
#        permission=$USER
#        CurrentUser=$SUDO_USER
#        if [ "$SUDO_USER" == "" ]; then
#            CurrentUser=$permission
#        fi
#        HomeDirectory="/home/wildfootw"
#    else
#        echo "Your distribution havn't been support yet. exit.."
#        exit 1
#    fi
    echo "Current Username: ($CurrentUser)"
    read
    if [ "$REPLY" != "" ]; then
        CurrentUser=$REPLY
    fi

    echo "Home Directory: ($HomeDirectory)"
    read
    if [ "$REPLY" != "" ]; then
        HomeDirectory=$REPLY
    fi

    echo "Script Location: ($ScriptLocation)"
    read
    if [ "$REPLY" != "" ]; then
        ScriptLocation=$REPLY
    fi

    echo "========================================================"
    echo "Home Directory: $HomeDirectory"
    echo "Current Username: $CurrentUser"
    echo "Script Location: $ScriptLocation"
    read -p "Are you sure? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}

function install_dotfiles_folder()
{
    if [ -e "$HomeDirectory/dotfiles" ]; then
        echo "dotfiles in $HomeDirectory existed"
    else
        echo "Link $ScriptLocation to $HomeDirectory"
        ln -s $ScriptLocation $HomeDirectory
    fi
}

function check_software()
{
    echo "checking $1..."
    if [ -x "`which $1`" ]; then
        echo "Done."
    else
        echo "$1 is not installed."
        exit 1
#        echo "$1 is not installed. installing..."
#        if [ "$distribution" == "Ubuntu" ]; then
#            apt-get install -y $1
#        elif [ "$distribution" == "CentOS Linux" ]; then
#            yum -y install $1
#        fi
    fi
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

initial

#check sudo
#if [ $permission != "root" ]; then
#    echo "You need to be sudo..., exit."
#    exit 1
#fi

#check and install softwares
#for software in ${softwares[@]}; do
#    check_software $software
#done

#clone submodule
echo "Cloning submodule..."
git submodule init
git submodule update

install_dotfiles_folder

# run setups
for subfolder in ${subfolders[@]}; do
    $ScriptLocation/$subfolder/setup.sh $CurrentUser $HomeDirectory $ScriptLocation
done

# make workplace dir
echo "create workplace directory"
$ScriptLocation/Misc/make_my_workplace_dir.sh

