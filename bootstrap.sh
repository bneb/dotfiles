#!/usr/bin/env bash

# Copy files into ~/ if necessary
cd "$(dirname "${BASH_SOURCE}")";

read -p "This may overwrite files in ~/. Proceed? (y/n)? " -n 1;
echo "";

git pull origin master;

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude "bootstrap.sh" \
  --exclude "README.md" \
  --exclude "LICENSE-MIT.txt" \
  --exclude ".macos" \
  --exclude "requirements.txt" \
  --exclude "pyfunk.py" \
  -avh --no-perms . ~;

cd -

# build ~/.extra
echo "" && echo "Please enter a tmux alias:" && read tmux_alias
echo "" && echo "Please enter a default tmux session name" && read tmux_session

cat << EOT > ~/.extra
# This file contains additional configurations
alias $tmux_alias="tmux a -t $tmux_session || tmux new -s $tmux_session"
EOT

# brew
if [ `which brew` != '/usr/local/bin/brew' ]; then
  /usr/bin/ruby -e \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
brew install coreutils
# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
echo PATH="$(brew --prefix coreutils)/libexec/gnubin":$PATH >> ~/.bash_profile
# zsh
brew install zsh
# oh-my-zsh
sh -c \
"$(curl -fsSL https://raw.githubusercontent.com/\
robbyrussell/oh-my-zsh/master/tools/install.sh)"
# gpg
brew install gpg
# more recent versions of macOs tools
brew install vim --with-override-system-vi
brew install homebrew/dupes/grep
# dark mode
brew install dark-mode
brew install git
# iTerm
brew install Caskroom/cask/iterm2
# Python3
brew install python3
# Remove outdated versions from the cellar.
brew cleanup

# Python virtual environments
pip install virtualenv
mkdir -p ~/.virtual_environments
cd ~/.virtual_environments
virtualenv -p python3 default
source default/bin/activate
pip install -Ur requirements.txt

source ~/.bash_profile;
