#!/bin/bash

# Absolute path to this script, e.g. /home/user/Pwngdb/install.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/Pwngdb
SCRIPTPATH=$(dirname "$SCRIPT")

source ./check_distribution.sh
echo "your distribution is $distribution $distribution_version"

files='vim vimrc zshrc tmux.conf'
softwares="git zsh vim tmux"
git_email="wild.foot.yee.tzwu@gmail.com"
git_name="WildfootW"

function initial() {
    if [ "$distribution" == "Ubuntu" ]; then
        permission=$USER
        current_user=$SUDO_USER
        home_directory=$HOME
    elif [ "$distribution" == "CentOS Linux" ]; then
        permission=$USER
        current_user=$SUDO_USER
        home_directory="/home/$SUDO_USER"
    else
        echo "Your distribution havn't been support yet. exit.."
        exit 1
    fi
}

function install_file() {
    dst="$home_directory/.$1"
    if [ -f $dst ] || [ -d $dst ]; then
        echo "File conflict: $dst"
    else
        src="$SCRIPTPATH/$1"
        echo "Link $src to $dst"
        ln -s $src $dst
        chown -h $current_user:$current_user $dst
    fi
}

function install_dotfiles_folder() {
    if [ -e "$home_directory/dotfiles" ]; then
        echo "dotfiles in $home_directory existed"
    else
        echo "Link $SCRIPTPATH to $home_directory"
        ln -s $SCRIPTPATH $home_directory
        chown -h $current_user:$current_user $home_directory/dotfiles
    fi
}

function check_software() {
    echo "checking $1..."
    if [ -x "`which $1`" ]; then
        echo "Done!"
    else
        echo "$1 is not installed. installing..."
        if [ "$distribution" == "Ubuntu" ]; then
            apt-get install -y $1
        elif [ "$distribution" == "CentOS Linux" ]; then
            yum -y install $1
        fi
    fi
}

function set_git_environment_settings() {
    echo "set git environment settings..."
    git config --global user.email $git_email
    git config --global user.name $git_name
    git config --global color.ui true
    git config --global core.editor vim 
    git config --global alias.co commit
    git config --global alias.lg "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
    git config --global push.default simple
}

function setup_GitHub_SSH_Key() {
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
if [ $permission != "root" ]; then
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
chsh -s /bin/zsh $current_user

# make workplace dir
echo "create workplace directory"
su $current_user ./make_my_workplace_dir.sh
