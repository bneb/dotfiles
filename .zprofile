# ~/.zprofile: Zsh login shell configuration

# macOS automatically reads /etc/paths and then ~/.zprofile for login shells.
# Since we have unified environment configuration in ~/.profile,
# we source it here to ensure it's loaded early in the login process.

if [ -f ~/.profile ]; then
    source ~/.profile
fi
