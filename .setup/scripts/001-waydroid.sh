#!/bin/bash
# https://gist.github.com/alexsch01/6dab644fc8348a6874098e53377ccc98


# Error handling
set -e

# Prompt for install
echo
echo -ne "${YELLOW}Install Waydroid? [Y]: ${NC}"
read -r install_waydroid < /dev/tty
echo
install_waydroid=${install_waydroid:-Y}
if [[ $install_waydroid =~ ^[Yy]$ ]]; then

  # Install build dependencies
  sudo apt update  -y
  sudo apt install -y \
    curl \
    build-essential \
    bc \
    flex \
    bison \
    libelf-dev \
    git \
    software-properties-common \
    lsb-release

  # Install LLVM tools
  LLVM_VERSION=18
  curl -L https://apt.llvm.org/llvm.sh | sudo bash -s "${LLVM_VERSION}"
  for f in clang clang++ ld.lld llvm-objdump llvm-ar llvm-nm llvm-strip llvm-objcopy llvm-readelf; do
    sudo ln -sf $f-$LLVM_VERSION /usr/bin/$f
  done


fi