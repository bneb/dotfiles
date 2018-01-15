#### My streamlined dotfiles using a different vim configuration and zsh.

---

### Installation Instructions

**First**, clone this repo wherever you'd like

``` bash
mkdir -p ~/Configurations
cd ~/Configurations
git clone git@github.com:bneb/dotfiles.git
```

**Second**, review, then run the main script.

``` bash
dotfiles/bootstrap.sh
```

###### _The following may help if Homebrew needs some help._

``` bash
sudo chown -R $(whoami):admin /usr/local
cd /usr/local && git reset --hard && git clean -df
cd -
dotfiles/bootstrap.sh
```

**Third**, review and run the .macos script if installing on a Mac.

``` bash
dotfiles/.macos
```

---

# ✌️
