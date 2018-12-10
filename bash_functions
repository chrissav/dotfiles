# vim: ft=sh

#### needed for zsh for completion
autoload bashcompinit
bashcompinit

##############################
#### Kubernetes functions ####
##############################

# Quickly display / switch kubernetes contexts
function kcsc
{
  local context=${1}
  if [[ -z "$context" ]]; then
    kubectl config get-contexts
  else
    kubectl config use-context ${context}
  fi
}

function _kcsc_complete {
    local word=${COMP_WORDS[COMP_CWORD]}
    local list=$(kubectl config get-contexts --no-headers | tr -d '\*' | awk '{print $1}')
    list=$(compgen -W "$list" -- "$word")
    COMPREPLY=($list)
    return 0
}
complete -F _kcsc_complete kcsc

# Quickly display / switch kubernetes namespaces
function kcns
{
  local namespace=${1}
  if [[ -z "$namespace" ]]; then
    kubectl get ns
  else
    local context=$(kubectl config current-context)
    echo "Setting context ${context} to namespace ${namespace}..."
    kubectl config set-context ${context} --namespace ${namespace}
  fi
}

function _kcns_complete {
    local word=${COMP_WORDS[COMP_CWORD]}
    local list=$(kubectl get ns --no-headers | awk '{print $1}')
    list=$(compgen -W "$list" -- "$word")
    COMPREPLY=($list)
    return 0
}
complete -F _kcns_complete kcns

# Grab a shell / execute a comand on a running pod
function kube-shell
{
  local pod=${1:?}
  shift

  # Some lazy argument parsing to see if a container is specified
  if  [[ "$1" == "-c" ]]; then
    shift
    local container=" -c ${1:?}"
    shift
  fi

  local cols=$(tput cols)
  local lines=$(tput lines)
  local term='xterm'
  local cmd=$@
  cmd=${cmd:-bash}

  kubectl exec -it $pod $container -- env COLUMNS=$cols LINES=$lines TERM=$term "$cmd"
}

# Reboot ec2 instance given the private ip dns from `kc get nodes` in the NotReady status
function kube-reboot
{
  instances=$(kc get nodes | grep NotReady | awk '{print $1}')
  if [ -z "$instances" ]
  then
    echo "No nodes found in NotReady status"
  else
    for instance in $instances; do
      local id=$(aws ec2 describe-instances --output text --filters Name=network-interface.private-dns-name,Values=$instance --query "Reservations[*].Instances[*].[InstanceId]")
      echo "------------------------------"
      echo "Rebooting ${id}..."
      echo "------------------------------"
      echo "Effected pods:\n"
      kubectl get pods --all-namespaces --field-selector spec.nodeName=$instance -o wide
      echo ""
      aws ec2 stop-instances --instance-ids $id --force
      aws ec2 wait instance-stopped --instance-ids $id
      returnval=$?
      if [ $? -ne 0 ]; then
        echo "There was a problem stopping the instance ${id}"
      else
        aws ec2 start-instances --instance-ids $id
        aws ec2 wait instance-running --instance-ids $id
        if [ $? -ne 0 ]; then
          echo "There was a problem starting the instance ${id}"
        else
          echo "Instance ${id} is running"
        fi
      fi
    done
  fi
}

##############################
###### Github functions ######
##############################

# Usage: `github-find searchstring`
# Searches an organizations code base for string
function github-find {
  curl -s -u $GITHUB_USERNAME:"$GITHUB_OAUTH" https://api.github.com/search/code\?q\=$1+in:file+org:$GITHUB_ORG | jq '.items | .[].html_url'
}

##############################
####### Misc functions #######
##############################

function scratch
{
  local file="$(date +%s).scratch"
  touch "$file"
  vim "$file"
}

# Display all the colors / ANSI codes available to the term
function showcolors
{
    for x in 0 1 4 5 7 8; do
        for i in `seq 30 37`; do
            for a in `seq 40 47`; do
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
            done
            echo
        done
    done
    echo ""
}

function weather
{
  # We require 'curl' so check for it
  if ! command -v curl &>/dev/null; then
    printf "%s\n" "[ERROR] weather: This command requires 'curl', please install it."
    return 1
  fi

  # If no arg is given, default to New York, NY
  (curl -sm 10 "http://wttr.in/${*:-NewYork}" 2>/dev/null \
    | grep -v 'New feature\|Follow') \
    || printf "%s\n" "[ERROR] weather: Could not connect to weather service."
}

# Function to extract common compressed file types
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        local nameInLowerCase=`echo "$1" | awk '{print tolower($0)}'`
        case "$nameInLowerCase" in
          *.tar.bz2)   tar xvjf ./"$1"    ;;
          *.tar.gz)    tar xvzf ./"$1"    ;;
          *.tar.xz)    tar xvJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xvf ./"$1"     ;;
          *.tbz2)      tar xvjf ./"$1"    ;;
          *.tgz)       tar xvzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
      else
        echo "'$1' - file does not exist"
      fi
  fi
}
