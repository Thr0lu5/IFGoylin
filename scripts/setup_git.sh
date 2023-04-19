#!/bin/bash
#
# Execute: setup_git.sh [USERNAME] [EMAIL]
#

#git config --global pull.rebase false
#git config --global push.default simple
if [[ $# -ge 2 ]]; then
  git config --global user.name "$1"
  git config --global user.email "$2"
  sudo git config --system core.editor nano
  git config --global credential.helper cache
  #git config --global credential.helper 'cache --timeout=32000'
  #git remote set-url origin git@github.com:$githubdir/$project
  echo; tput setaf 5
  echo "Git configurado para $1 - $2"
  echo; tput sgr0
else
  echo 'Execute: setup_git.sh [USERNAME] [EMAIL]'
fi