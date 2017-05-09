###### See original project for information for a lot of useful information.
###### Several things have changed, but for the most part, installation and the like are the same.

### Installation Instructions

**First**, clone this repo wherever you'd like

``` bash
mkdir -p ~/Configurations
cd ~/Configurations
git clone git@github.com:bneb/dotfiles.git
```

**Second**, create a symbolic link in the home directory

``` bash
cd ~
ln -s ~/Configurations/dotfiles dotfiles
```

**Third**, run the script to copy files into the home directory

``` bash
dotfiles/bootstrap.sh
```

**Fourth**, run the script to install some useful software (This updates bash and sets it to the default shell)

``` bash
dotfiles/brew.sh
```

###### _If you see some errors in the last step, Homebrew needs some help. Try the following:_

``` bash
sudo chown -R $(whoami):admin /usr/local
cd /usr/local
git reset --hard
git clean -df
cd -
brew update
dotfiles/brew.sh
```

**Fifth**, review (and make optional modifications) and run the .macos script if installing on a Mac.

``` bash
dotfiles/.macos
```

**Sixth**, run an interactive bash script to build some custom configurations

``` bash
dotfiles/build_extra.sh
```
