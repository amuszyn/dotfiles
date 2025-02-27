#!/bin/sh

WORKING_DIR=$(pwd)

# Basic zsh config

echo "export EDITOR='nvim'
export VISUAL='nvim'
alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git branch -r'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gl='git log'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'
" >> ~/.zshrc

checkCommand() {
	if ! command -v $1 2>&1 >/dev/null
	then
		return 0 # fail
	else
		return 1 # success
	fi
}

checkDirExists() {
	if [-d "$1" ]; then
		cd "$1" || exit 1
		echo "Now in $(pwd)"

		cd WORKING_DIR || exit 1 
	else 
		echo "Dir $1 does not exist"
	fi
}

if checkCommand uv
then
	echo "uv not found, installing..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if checkCommand brew
then
	echo "brew not found, installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install alacritty neovim ripgrep nvm node tmux colima zoxide zsh-autosuggestions

# put nvm on .zshrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"' >> ~/.zshrc  # This loads nvm
echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"' >> ~/.zshrc # This loads nvm bash_completion

source ~/.zshrc

if checkCommand nvm
then
	echo "nvm source likely failed"
fi

fontDir="$HOME/Library/Fonts"
fontFile="JetBrainsMonoNerdFontMono-Regular.ttf"
# check if font already exists, if not install it
if [ -d "$fontDir" ]; then
	cd "$fontDir" || exit 1

	if [ ! -f "$fontFile"  ]; then
		curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf


	else
		echo "Already have nerd font"
	fi

	cd "$WORKING_DIR" || exit 1 
else 
	echo "Dir $fontDir does not exist"
fi


if checkCommand ssh -T git@github.com
then
	echo "no ssh key for git configured, configure and re-run"
	exit 1
else
	configDir="$HOME/.config"
	nvimDir="$HOME/.config/nvim"
	if [ ! -d "$nvimDir" ]; then
		# Install nvim config
		cd "$configDir"  
		git clone git@github.com:amuszyn/kickstart.nvim.git nvim
		cd "$WORKING_DIR"
	else
		echo "Neovim config already exists"
	fi
	alacrittyDir="$HOME/.config/alacritty"
	if [ ! -d "$alacrittyDir" ]; then
		# Install alacritty config
		cd "$configDir"  
		git clone git@github.com:amuszyn/alacritty-config.git alacritty
		source alacritty/alacritty.toml
		cd "$WORKING_DIR"
	else
		echo "Alacritty config already exists"
	fi
fi


