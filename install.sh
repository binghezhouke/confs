#!/usr/bin/env bash

set -x
set -e

SUDO=
if [[ $EUID -ne 0 ]]; then
	SUDO=sudo
fi

function get_host_type(){
case $(uname -a) in
    *Ubuntu* )
        hosttype="Ubuntu";;
    *Arch*)
        hosttype="Arch";;
    *Darwin*)
        hosttype="Mac";;
        **)
        echo "unknown";;
esac
}

if [ -z "$1" ];then
get_host_type
PLATFORM=${hosttype}
else 
PLATFORM=${1}
fi

echo "detected platform is ${PLATFORM}"
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
    ( command -v "$1" && echo "$1 installed") || (echo "$1 not installed" && $2 )
}


function install_basic_ubuntu(){
    $SUDO apt-get update
    for x in vim zsh git tmux curl python3 python3-pip awk; do
        check_and_install $x "$SUDO apt-get install -y $x"
    done
}

function install_basic_arch(){
    $SUDO pacman -Syyuu
    for x in vim zsh git tmux curl awk python python-pip neovim; do
        check_and_install "$x" "$SUDO pacman -Sy --noconfirm $x"
    done
}

function install_basic_mac(){
    echo "begin install basic for mac"
    if command -v brew ;then
        echo "brew installed"
    else
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew update
    for x in vim zsh git tmux curl awk;do
        check_and_install "$x" "brew install -y ${x}"
    done

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
	pushd "$(pwd)"
    cd ${DIR_NAME}
    git pull origin master
    popd
else
    git clone https://github.com/binghezhouke/confs.git ${DIR_NAME}
fi

confs=(clang-format tmux.conf)
for x in "${confs[@]}"
do
    if [ -f ".${x}" ] ; then
        echo found ".${x}"
        cp -rp ".${x}" ".${x}.bak"
        rm -rf ".${x}"
    fi
    ln -s "${DIR_NAME}/${x}" ".${x}"
done

    if [ -d ~/.vim_runtime ]; then
	    pushd "$(pwd)"
        cd ~/.vim_runtime
        git pull origin master
        popd
    else
        git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    fi
    source ~/.vim_runtime/install_awesome_vimrc.sh
    ln -sf ~/.binghe/my_configs.vim ~/.vim_runtime/my_configs.vim
    rm -rf ~/.oh-my-zsh

    curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh > tmp.sh
    bash tmp.sh --unattended
    rm tmp.sh
tmux source-file ~/.tmux.conf || echo "success"
}

make_confs

function update_git(){
    echo "$1" "$2"
if [ -d "$1" ];then
    cd "$1"
    git pull
else
    git clone "$2"
fi

}

function update_confs() {
    read -r -p "Install vim confs(yes||no):  " INSTALL
if [ "$INSTALL" != "yes" ] ;then
    return 0;
fi
pushd "$(pwd)"
cd ~/.vim_runtime/my_plugins
update_git "vim-codefmt" "https://github.com/google/vim-codefmt.git"
update_git "vim-maktaba" "https://github.com/google/vim-maktaba.git"
update_git "vim-glaive" "https://github.com/google/vim-glaive.git"
popd
}
update_confs

function install_nvim(){
    read -r -p "Install nvim confs(yes||no):  " INSTALL
if [ "$INSTALL" != "yes" ] ;then
    return 0;
fi
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.config/nvim/
ln -sf ~/.binghe/init.vim ~/.config/nvim/
pip3 install neovim
}
install_nvim
