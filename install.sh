#!/usr/bin/env bash

set -x
set -e
read -r -p "Please input your platform(Arch|Ubuntu|Mac)" PLATFORM 

function platform_run(){
    case "${PLATFORM}" in
        Mac)
            echo "mac platform"
            $1;
            ;;
        Ubuntu)
            echo "ubuntu"
            $2;
            ;;
        Arch)
            echo "arch "
            $3
            ;;
        *)
            echo "bad platform"
            exit 1
            ;;
    esac
}


function check_and_install() {
    ( which "$1" && echo "$1 installed") || (echo "$1 not installed" && $2 )
}


function install_basic_ubuntu(){
    sudo apt-get update
    for x in vim zsh git tmux; do
        check_and_install $x "sudo apt-get install -y $x"
    done
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sh <(curl https://j.mp/spf13-vim3 -L)
}

function install_basic_arch(){
    sudo pacman -Syyuu
    for x in vim zsh git tmux; do 
        check_and_install "$x" "sudo pacman -Sy --noconfirm $x"
    done
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sh <(curl https://j.mp/spf13-vim3 -L)
}

function install_basic_mac(){
    echo "begin install basic for mac"
    if which brew ;then
        echo "brew installed"
    else
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew update
    for x in vim zsh git tmux;do 
        check_and_install "$x" "brew install -y ${x}"
    done
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sh <(curl https://j.mp/spf13-vim3 -L)

    return 0;
}

read -r -p "Install basics(yes||no):  " INSTALL
if [ "$INSTALL" == "yes" ] ;then
    platform_run install_basic_mac install_basic_ubuntu install_basic_arch
fi

function make_confs() {
    read -r -p "Install confs(yes||no):  " INSTALL
if [ "$INSTALL" != "yes" ] ;then
    return 0;
fi

DIR_NAME=.binghe

cd ~

if [ -d ${DIR_NAME} ]; then
    echo "found existing ${DIR_NAME} dir,move it"
    mv ${DIR_NAME} ${DIR_NAME}-"$(date  "+%Y%m%d-%H%M%S")"
fi
git clone https://github.com/binghezhouke/confs.git ${DIR_NAME}

confs=(vimrc.before.local clang-format tmux.conf)
for x in "${confs[@]}"
do
    if [ -f ".${x}" ] ; then
        echo found ".${x}"
        cp -rp ".${x}" ".${x}.bak"
        rm -rf ".${x}"
    fi
    ln -s "${DIR_NAME}/${x}" ".${x}"
done
tmux source-file ~/.tmux.conf 
}

make_confs
