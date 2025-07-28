#!/bin/bash
__info__="""
# Name: Zsh Setup
# Version: 1.0.0
# Description: Brief purpose description
# Usage: _zsh_setup.sh [options] [arguments]
# Options:
#   -h --help    Show this help
#   -v --version Show version
"""
set -euo pipefail

help() {
	echo "$__info__"
    exit 0
}
version() {
    echo "Version: $(grep '^# Version:' "$0" | cut -d' ' -f3)"
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) help ;;
        -v|--version) version ;;
        -*) echo "Unknown option: $1" >&2; exit 1 ;;
        *) break ;;
    esac
    shift
done

# Main script content here

# Create a backup of .zshrc with date
echo "Backing up .zshrc..."
if [ -f $HOME/.zshrc ]; then
    cp $HOME/.zshrc $HOME/.zshrc_setup.$(date +%Y%m%d%H%M%S)
fi

echo "Installing OhMyZsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Powerlevel10k in ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# sets ZSH_THEME, and change its value to "powerlevel10k/powerlevel10k"
mod_script $HOME/.zshrc --mod_var ZSH_THEME "\"powerlevel10k/powerlevel10k\""

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install zsh-you-should-use
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use

# install zsh-bat
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat

# Set plugins
__plugins__=(
sudo aliases alias-finder history emoji encode64
git gh
dotenv 
themes 
tmux kubectl  
zsh-autosuggestions
zsh-syntax-highlighting colorize 
you-should-use
zsh-bat
web-search)

mod_script $HOME/.zshrc --mod_var plugins "($__plugins__)"