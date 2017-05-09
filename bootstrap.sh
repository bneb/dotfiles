#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
                --exclude "build_extra.sh" \
                --exclude "change_prompt.sh" \
                --exclude ".macos" \
                --exclude "brew.sh" \
                --exclude "bin" \
                --exclude "vim" \
		-avh --no-perms . ~;

        if [[ "$(readlink $HOME/.vim)" == *"vim_dotfiles/vim"* ]]; then
                cp .vim/colors/s* $HOME/.vim/colors/
                cp .vimrc $HOME/.vimrc_local
                mkdir -p $HOME/.vim/backups 2>/dev/null
        else
                cp -r .vim $HOME/.vim
                cp .vimrc $HOME/.vimrc
        fi;

        echo 'source ~/virtualenvs/default/bin/activate' >> ~/.bash_profile
        echo "execute pathogen#infect()" >> ~/.vimrc

        mkdir -p ~/.vim/bundle 2>/dev/null
        cd ~/.vim/bundle
        git clone git://github.com/tpope/vim-sensible.git
        git clone https://github.com/scrooloose/nerdtree.git
        git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git
        git clone https://github.com/tpope/vim-surround.git
        git clone https://github.com/scrooloose/syntastic.git
        git clone https://github.com/bling/vim-airline.git
        git clone https://github.com/valloric/youcompleteme.git
        git clone git://github.com/godlygeek/tabular.git
        git clone git://github.com/ervandew/supertab
        cd -

        echo '" Start NERDTree when no file is passed to vim' >> ~/.vimrc
        echo autocmd StdinReadPre * let s:std_in=1 >> ~/.vimrc
        echo 'autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif' >> ~/.vimrc

	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

cd -
