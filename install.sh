#!/bin/bash

# Absolute path to this script, e.g. /home/user/Pwngdb/install.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/Pwngdb
SCRIPTPATH=$(dirname "$SCRIPT")

files='vim vimrc zshrc tmux.conf'
softwares="git zsh vim tmux"
git_email="wild.foot.yee.tzwu@gmail.com"
git_name="WildfootW"

function install_file() {
    dst="$HOME/.$1"
    if [ -f $dst ] || [ -d $dst ]; then
        echo "File conflict: $dst"
    else
        src="$SCRIPTPATH/$1"
        echo "Link $src to $dst"
        ln -s $src $dst
    fi
}

function install_dotfiles_folder() {
    if [ -e "$HOME/dotfiles" ]; then
        echo "dotfiles in home directory existed"
    else
        echo "Link dotfile to home directory"
        ln -s $SCRIPTPATH $HOME
    fi
}

function check_software() {
    echo "checking $1..."
    if [ -x "`which $1`" ]; then
        echo "Done!"
    else
        echo "$1 is not installed. installing..."
        apt-get install -y $1
    fi
}

function set_git_environment_settings() {
    git config --global user.email $git_email
    git config --global user.name $git_name
    git config --global color.ui true
    git config --global core.editor vim 
    git config --global alias.co commit
    git config --global alias.lg "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
}

function setup_GitHub_SSH_Key() {
    echo "Setup GitHub SSH Key..."

    if [ -e "$HOME/.ssh" ]; then
        if [ ! -d "$HOME/.ssh" ];then
            echo ".ssh exist in HOME directory but not a directory!"
            echo "GitHub SSH Key setup failed!"
            exit 1
        fi
    else
        mkdir "$HOME/.ssh"
        chgrp $SUDO_USER $HOME/.ssh
        chown $SUDO_USER $HOME/.ssh
    fi
#    if [ -e "$HOME/.ssh/GitHub" ]; then
#        echo "$HOME/.ssh/GitHub exist"
#        echo "GitHub SSH Key setup failed!"
#        exit 1
#    fi

    ssh-keygen -t rsa -C $git_email -f "$HOME/.ssh/GitHub" -b 2048 -q -N ""
    #-q Silence ssh-keygen -N new_passphrase
    chgrp $SUDO_USER $HOME/.ssh/GitHub
    chown $SUDO_USER $HOME/.ssh/GitHub
    eval $(ssh-agent)
    ssh-add $HOME/.ssh/GitHub

    echo "Success!! please paste the public key to GitHub."
    echo "+------------------------------------------------+"
    cat $HOME/.ssh/GitHub.pub
    echo "+------------------------------------------------+"
    echo "After pasted the public key. Use \"ssh -T git@github.com\" to test if setup success."
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

#check sudo
if [ $USER != "root" ]; then
    echo "You need to be sudo..., exit."
    exit 1
fi

#check and install softwares
for software in `echo $softwares | tr ' ' '\n'`; do
    check_software $software
done

#clone submodule
echo "Cloning oh-my-zsh..."
git submodule init
git submodule update

#set git and GitHub SSH Key
set_git_environment_settings
setup_GitHub_SSH_Key

#install files and folders
for file in `echo $files | tr ' ' '\n'`; do
    install_file $file
done
install_dotfiles_folder

#install vim plugins
echo "Install vim plugins"
vim +qall

#switch to zsh
echo "change default shell to zsh"
chsh -s /bin/zsh $SUDO_USER
