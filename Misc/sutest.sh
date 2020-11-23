#!/bin/sh
echo "user is $USER"
echo "username is $USERNAME"
echo "sudouser is $SUDO_USER"
echo "home directory is $HOME"

sudo -u $SUDO_USER echo "user is $USER"
sudo -u $SUDO_USER echo "username is $USERNAME"
sudo -u $SUDO_USER echo "sudouser is $SUDO_USER"

