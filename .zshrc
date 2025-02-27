. "$HOME/.local/bin/env"

function git_branch_name() {
  # Check if we're inside a Git repository
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return # Exit silently if not in a Git repo
  fi

  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -z "$branch" ]]; then
    return  # Exit silently if no branch is detected
  elif [[ "$branch" == "HEAD" ]]; then
    branch_display="\e[33m$branch\e[0m"  # Yellow for HEAD (detached state)
  else
    branch_display="\e[32m$branch\e[0m"  # Green for branch
  fi

  # Only check Git status if inside a repo (avoiding `git diff` errors)
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if git diff --cached --quiet; then
      staged_changes=""
    else
      staged_changes="1"  # Staged changes exist
    fi

    if git diff --quiet; then
      unstaged_changes=""
    else
      unstaged_changes="1"  # Unstaged changes exist
    fi

    # Decide symbol based on changes
    if [[ -n "$staged_changes" && -n "$unstaged_changes" ]]; then
      branch_display+="\e[33m+\e[0m"  # Yellow `+` if both staged & unstaged changes exist
    elif [[ -n "$staged_changes" ]]; then
      branch_display+="\e[36m+\e[0m"  # Cyan `+` if only staged changes exist
    elif [[ -n "$unstaged_changes" ]]; then
      branch_display+="\e[31m-\e[0m"  # Red `-` if only unstaged changes exist
    fi
  fi

  echo -e "($branch_display)"
}

setopt PROMPT_SUBST
PROMPT='[%n@%m %1~]$(git_branch_name)%F{white}$ '

fpath+=${ZDOTDIR:-~}/.zsh_functions
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

export EDITOR='nvim'
export VISUAL='nvim'
alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git restore'
alias grb='git rebase'
alias grs='git restore --staged'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gl='git log'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty=oneline'
alias glol='git log --graph --oneline --decorate'

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/amusynski/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

eval "$(zoxide init zsh --cmd cd --hook pwd)"
