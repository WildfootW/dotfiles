#!/bin/bash
#fork from https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    distribution=$NAME
    distribution_version=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    distribution=$(lsb_release -si)
    distribution_version=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    distribution=$DISTRIB_ID
    distribution_version=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    distribution=Debian
    distribution_version=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    distribution=$(uname -s)
    distribution_version=$(uname -r)
fi

#echo $distribution
#echo $distribution_version
