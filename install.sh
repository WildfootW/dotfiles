#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

# Absolute path to this script, z.B. /home/user/Pwngdb/install.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/Pwngdb
SCRIPTLOCATION=$(dirname "$SCRIPT")

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
#        current_user=$SUDO_USER
#        home_directory=$HOME
#    elif [ "$distribution" == "CentOS Linux" ]; then
#        permission=$USER
#        current_user=$SUDO_USER
#        home_directory="/home/$SUDO_USER"
#    elif [ "$distribution" == "Kali GNU/Linux" ]; then
#        permission=$USER
#        current_user=$SUDO_USER
#        if [ "$SUDO_USER" == "" ]; then
#            current_user=$permission
#        fi
#        home_directory="/home/wildfootw"
#    else
#        echo "Your distribution havn't been support yet. exit.."
#        exit 1
#    fi
    echo "Current Username: ($USER)"
    read current_user
    if [ "$current_user" == "" ]; then
        current_user=$USER
    fi

    echo "Home Directory: ($HOME)"
    read home_directory
    if [ "home_directory" == "" ]; then
        home_directory=$HOME
    fi

    echo "Script Location: ($SCRIPTLOCATION)"
    read _script_path_input
    if [ "$_script_path_input" != "" ]; then
        SCRIPTLOCATION=$_script_path_input
    fi
}

function install_file()
{
    dst="$home_directory/.$1"
    if [ -f $dst ] || [ -d $dst ]; then
        echo "File conflict: $dst"
    else
        src="$SCRIPTLOCATION/$1"
        echo "Link $src to $dst"
        ln -s $src $dst
        chown -h $current_user:$current_user $dst
    fi
}

function install_dotfiles_folder()
{
    if [ -e "$home_directory/dotfiles" ]; then
        echo "dotfiles in $home_directory existed"
    else
        echo "Link $SCRIPTLOCATION to $home_directory"
        ln -s $SCRIPTLOCATION $home_directory
        chown -h $current_user:$current_user $home_directory/dotfiles
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
    if [ -e "$home_directory/.ssh" ]; then
        if [ ! -d "$home_directory/.ssh" ];then
            echo ".ssh exist in HOME directory but not a directory!"
            echo "GitHub SSH Key setup failed!"
            exit 1
        fi
    else
        mkdir "$home_directory/.ssh"
        chown $current_user:$current_user $home_directory/.ssh
    fi
#    if [ -e "$home_directory/.ssh/GitHub" ]; then
#        echo "$home_directory/.ssh/GitHub exist"
#        echo "GitHub SSH Key setup failed!"
#        exit 1
#    fi

    ssh-keygen -t rsa -C $git_email -f "$home_directory/.ssh/GitHub" -b 2048 -q -N ""
    #-q Silence ssh-keygen -N new_passphrase
    chown $current_user:$current_user $home_directory/.ssh/GitHub
    chown $current_user:$current_user $home_directory/.ssh/GitHub.pub

    eval $(ssh-agent)
    ssh-add $home_directory/.ssh/GitHub

    echo "Success!! please paste the public key to GitHub."
    echo "+------------------------------------------------+"
    cat $home_directory/.ssh/GitHub.pub
    echo "+------------------------------------------------+"
    echo "After pasted the public key. Use \"ssh -T git@github.com\" to test if setup success."
    echo "If it is not working. Just command \"ssh-add $home_directory/.ssh/GitHub\" manually."
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
git clone https://github.com/zsh-users/zsh-autosuggestions $SCRIPTLOCATION/oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SCRIPTLOCATION/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

#set git and GitHub SSH Key
set_git_environment_settings
setup_GitHub_SSH_Key

#install files and folders
for file in ${files[@]}; do
    install_file $file
done
install_dotfiles_folder
ln -s $SCRIPTLOCATION/ssh-config $home_directory/.ssh/config

#install vim plugins
echo "Install vim plugins"
vim +qall

#switch to zsh
echo "change default shell to zsh"
chsh -s /bin/zsh $current_user

# make workplace dir
echo "create workplace directory"
#su $current_user ./make_my_workplace_dir.sh
./make_my_workplace_dir.sh

# change owner in dotfiles back to user
#echo "change owner"
#chown -R $current_user:$current_user $SCRIPTLOCATION
