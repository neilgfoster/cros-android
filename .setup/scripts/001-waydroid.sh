#!/bin/bash
# https://gist.github.com/alexsch01/6dab644fc8348a6874098e53377ccc98

# Error handling
set -e

# Set kernel version variable
KERNEL_VERSION="chromeos-6.6"

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

  # Navigate to the correct directory and clone
  folders=(".setup" "cros-android" "cros-kernel" "neilgfoster" "chromiumos")
  for folder in "${folders[@]}"; do
    if [ "$(basename "$PWD")" = "$folder" ]; then
      cd ..
    fi
  done
  mkdir -p "chromiumos"
  cd "chromiumos"
  if [ ! -d "cros-kernel" ]; then
    git clone https://chromium.googlesource.com/chromiumos/third_party/kernel cros-kernel -b "$KERNEL_VERSION" --depth=1
  fi
  cd cros-kernel

  # Prepare the kernel configuration
  CHROMEOS_KERNEL_FAMILY=termina ./chromeos/scripts/prepareconfig container-vm-x86_64
  make LLVM=1 LLVM_IAS=1 olddefconfig

  echo -e "${YELLOW}Press <Enter> to continue:${NC}"
  read -r dummy < /dev/tty

  # Enable Binder IPC support
  # make LLVM=1 LLVM_IAS=1 menuconfig 

fi