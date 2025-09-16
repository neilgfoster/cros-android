#!/bin/bash

# Error handling
set -e

# Color variables
YELLOW="\033[1;33m"
PURPLE="\033[0;35m"
RED="\033[1;31m"
GREEN="\033[1;32m"
NC="\033[0m"

# Export color variables for use in sourced scripts
export YELLOW PURPLE RED GREEN NC

# Parse arguments for ORG and REPO
for arg in "$@"; do
  case $arg in
    -o=*)
      ORG="${arg#*=}"
      ;;
    -r=*)
      REPO="${arg#*=}"
      ;;
  esac
done


# Devcontainer check
# if repo contains .devcontainer folder but not running in a devcontainer, exit
if [ -d ".devcontainer" ] && [ "${DEVCONTAINER}" != "true" ]; then
  echo -e "${RED}Detected .devcontainer folder but not running in a devcontainer environment. Exiting${NC}"
  exit 0
fi

# Do not execute this section if running in a devcontainer
if [ "${DEVCONTAINER}" != "true" ]; then

  # Navigate to the correct directory and clone
  if [[ -n "$ORG" && -n "$REPO" ]]; then
    sudo apt install -y git
    folders=(".setup" "base" "cros-base" "cros-setup" "$REPO" "$ORG")
    for folder in "${folders[@]}"; do
      if [ "$(basename "$PWD")" = "$folder" ]; then
        cd ..
      fi
    done
    mkdir -p "$ORG"
    cd "$ORG"
    if [ ! -d "$REPO" ]; then
      git clone "https://github.com/$ORG/$REPO.git"
    fi
    cd "$REPO"
    git pull
    ./.setup/setup.sh
    exit 0
  fi

  # Prompt user for branch to checkout
  echo
  echo -ne "${YELLOW}Specify the branch to checkout [main]: ${NC}"
  read BRANCH_NAME < /dev/tty
  echo
  BRANCH_NAME=${BRANCH_NAME:-main}
  git checkout "$BRANCH_NAME"
fi

# Determine the directory of this setup.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Resolve to absolute path
SCRIPTS_DIR="$(realpath "$SCRIPTS_DIR")"

# Find all .sh files that start with a three digit number,
# sort alphabetically, and execute them
find "$SCRIPTS_DIR" -maxdepth 1 -type f -name "[0-9][0-9][0-9]*.sh" |
  sort |
  while read -r script; do
    echo
    echo -e "${PURPLE}Executing $script...${NC}"
    echo
    source "$script"
  done