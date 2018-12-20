
export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="cloud"

plugins=(
  git
)

# install oh-my-zsh from https://github.com/robbyrussell/oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load .bashrc and other files...
for file in ~/.{bashrc,aliases,functions,extra}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    source "$file"
  fi
done
