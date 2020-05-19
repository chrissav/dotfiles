
export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="cloud"

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

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="/usr/local/opt/python/libexec/bin:$HOME/.rvm/bin:/usr/local/sbin:/usr/local/opt/qt@5.5/bin/:$PATH"
