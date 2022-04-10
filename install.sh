#!/bin/bash

set -x

function pre_scripts_install() { 
  xcode-select --install 2> /dev/null || print_warning "Xcode CLI tools already installed"
}

function install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function is_installed() {
  [ `command -v "$1"` 2>/dev/null ] && echo true || echo false
}

function brew_install() {
  if $( ! is_installed "brew" ); then
    /bin/bash -c "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh )" 
  fi
  
  # GUI apps
  brew install --cask firefox # primary browser 
  brew install --cask raycast # best relacement of spotlight and smol tools
  brew install --cask iina # best video player
  brew install --cask telegram # best messanger
  brew install --cask airbuddy # better airpods experience 
  brew install --cask iterm2 # best terminal 
  brew install --cask fork # amazing git client
  brew install --cask sublime-text # amazing text editor
  brew install --cask sublime-merge # another amazing git client
  brew install --cask visual-studio-code 
  brew install --cask paw # api tool (http client and more)
  brew install --cask transmission # torrent client 
  brew install --cask discord
  brew install --cask slack
  brew install --cask dash
  brew install --cask obsidian
  brew install --cask spotify

  # cli 
  brew install ripgrep # better grep
  brew install fd # better find
  brew install jq # json processor
  brew install micro # cli text editor
  brew install shellcheck # tool for static analysis of shellscript
  brew install bat # beautiful printing directly to terminal
  brew install exa # modern ls replacement
  brew install httpie # fancy curl
  brew install tldr # short intro to any command
  brew install gh # working with github from cli
  brew install coreutils # some linux utils that now available by default on macOS
  brew install gnupg # gpg
  brew install fzf # fuzzy search 
  $(brew --prefix)/opt/fzf/install
  brew install lazygit # better work with git from cli
  brew install tree # print tree of directories structure
  brew install git-delta # syntax-highlighting pager for git, diff, and grep output
  brew install fig # autocomplete tool

  # apple
  brew install cocoapods 
  gem install xcode-install
}

function dotfiles_install() {
  export DOTFILES_PATH="$( cd "$(dirname "$0")" && pwd )"
  (cd $DOTFILES_PATH && git submodule update --init --recursive) 
  source "$DOTFILES_PATH/shell/exports.sh"
  source "$DOTFILES_PATH/shell/functions.sh"
  ln -sF "$DOTFILES_PATH/.zshrc" "$HOME"
  # (cd "$DOTFILES_DEPENDECIES_PATH/xcode_theme" && ./install.sh) 
  # set_personal_macos_defaults
}

function configs_install() {

  # git
  ln -sF "$DOTFILES_CONFIG_PATH/git/.gitconfig" ~/.gitconfig 
  ln -sF "$DOTFILES_CONFIG_PATH/git/.github_token" ~/.github_token 
  ln -sF "$DOTFILES_CONFIG_PATH/git/.gitignore" ~/.gitignore 
  
  # run crontab
  crontab "$DOTFILES_CONFIG_PATH/auto_backups/cronetab.txt" && crontab -l 
  
  # micro
  ln -sF "$DOTFILES_CONFIG_PATH/micro" ~/.config/
    
  # vscode
  local VSCODE_PATH="$DOTFILES_CONFIG_PATH/vscode/"
  xargs -L1 code --install-extension < "$VSCODE_PATH/extensions.txt"
  ln -sF "$VSCODE_PATH/settings.json" ~/Library/Application\ Support/Code/User/settings.json
    
  # iterm2
  print_warning "iTerm needs manual install of config"
  mk "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch/"
  ln -sF "$DOTFILES_CONFIG_PATH/iterm/auto_dark_mode.py" ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/auto_dark_mode.py

  # color picker
  cp "$DOTFILES_CONFIG_PATH/color_picker/Color Picker.app" "/Applications"

  # sublime 
  ln -sF "$DOTFILES_CONFIG_PATH/sublime/sublime-profiles/" "$HOME/Library/Application Support/Sublime Text/Packages/"
  ln -sF "$DOTFILES_CONFIG_PATH/sublime/User" "$HOME/Library/Application Support/Sublime Text/Packages/"

  # sublime merge
  print_success "Installing CLI tool of Sublime Merge..."
  sudo ln -sF "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" "/usr/local/bin"

  # fig

}

function keys_install() {
  # gpg key
  # brew install gpg-suite && print_warning "Go and generate a new GPG key"
  # gpg --list-secret-keys --keyid-format LONG (get A3CDF698F9B37035 from this)
  # gpg --armor --export A3CDF698F9B37035
  # add to github
  
  # ssh for github
  print_warning "Go and generate SSH key in Xcode"
  # ssh-keyscan github.com >> ~/.ssh/known_hosts
}

function additional_setup() { 
  print_warning "SF Mono install needed" 
  print_warning "Raycast config needed"
}

pre_scripts_install
brew_install
dotfiles_install
configs_install
keys_install
additional_setup
source "$HOME/.zshrc"
