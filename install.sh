#!/usr/bin/env bash

set -x
set -e

DIR_NAME=.binghe

cd ~

if [ -d ${DIR_NAME} ]; then
    echo "found existing ${DIR_NAME} dir,move it"
    mv ${DIR_NAME} ${DIR_NAME}-"$(date  "+%Y%m%d-%H%M%S")"
fi
git clone git@github.com:binghezhouke/confs.git ${DIR_NAME}

confs=(vimrc tmux.conf)
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
