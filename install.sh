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

source ./check_distribution.sh
echo "your distribution is $distribution $distribution_version"

files=(vim vimrc zshrc tmux.conf tmux.conf.local)
#softwares=(git zsh vim tmux) # fonts-powerline
git_email="wildfootw@wildfoo.tw"
git_name="WildfootW"

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

function set_git_environment_settings()
{
    echo "set git environment settings..."
    git config --global user.email $git_email
    git config --global user.name $git_name
    git config --global color.ui true
    git config --global core.editor vim 
    git config --global alias.co commit
    git config --global alias.lg "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
    git config --global push.default simple
    git config --global pull.rebase false
    git config --global core.excludesfile ~/dotfiles/git/.gitignore # global gitignore
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

# clone some custom plugin
git clone https://github.com/zsh-users/zsh-autosuggestions $ScriptLocation/oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ScriptLocation/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

#set git and GitHub SSH Key
set_git_environment_settings
setup_GitHub_SSH_Key

#install files and folders
for file in ${files[@]}; do
    install_file $file
done
install_dotfiles_folder
ln -s $ScriptLocation/ssh-config $HomeDirectory/.ssh/config

#install vim plugins
echo "Install vim plugins"
vim +qall

#switch to zsh
echo "change default shell to zsh"
chsh -s /bin/zsh $CurrentUser

# make workplace dir
echo "create workplace directory"
#su $CurrentUser ./make_my_workplace_dir.sh
./make_my_workplace_dir.sh

