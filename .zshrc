# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="${HOME}/.oh-my-zsh"

# ZSH_THEME="cloud"
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins=(
  git
)

# install oh-my-zsh from https://github.com/robbyrussell/oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load .bashrc and other files...
for file in ~/.{bashrc,aliases,functions,extras}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    source "$file"
  fi
done

export PATH="/Users/csavadel/development/Search/tools:~/.pyenv/shims:/usr/local/opt/gradle@6/bin:${KREW_ROOT:-$HOME/.krew}/bin:${HOME}/go/bin:/usr/local/opt/krb5/sbin:/usr/local/opt/python/libexec/bin:${HOME}/.krew/bin:$HOME/.rvm/bin:/usr/local/sbin:/usr/local/opt/qt@5.5/bin/:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

source /Users/csavadel/.docker/init-zsh.sh || true # Added by Docker Desktop
