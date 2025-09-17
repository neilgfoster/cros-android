#!/bin/bash
# https://gist.github.com/alexsch01/6dab644fc8348a6874098e53377ccc98

# Error handling
set -e

# Set kernel version variable
KERNEL_VERSION="chromeos-6.6"

# Check for Binder IPC support in running kernel
if ! zgrep -q 'CONFIG_ANDROID_BINDERFS=y' /proc/config.gz; then

  # Prompt for install
  echo
  echo -ne "${YELLOW}Build kernel with Binder IPC Support? [Y]: ${NC}"
  read -r build_kernel < /dev/tty
  echo
  build_kernel=${build_kernel:-Y}
  if [[ $build_kernel =~ ^[Yy]$ ]]; then

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

    # Setup kernel configuration for Binder IPC
    echo
    echo -e "${YELLOW}Manual configuration of kernel build configuration required.${NC}"
    echo -e "${YELLOW}Follow these steps: https://github.com/neilgfoster/cros-android?tab=readme-ov-file#prepare-kernel-build-configuration${NC}"
    echo -ne "${YELLOW}Press <Enter> to continue: ${NC}"
    read -r dummy < /dev/tty
    echo

    # Build the kernel
    make LLVM=1 LLVM_IAS=1 bzImage -j$(nproc)

    # Copy the kernel image to home directory
    mkdir -p ~/kernels
    cp arch/x86/boot/bzImage ~/kernels/custom-kernel.img

    # Inform the user of success
    echo
    echo -e "${YELLOW}Kernel build complete${NC}"
    echo -e "${YELLOW}Kernel image location: ~/kernels/kernel.img ${NC}"
    echo -e "${YELLOW}Manual steps required to use this kernel for Linux .${NC}"
    echo -e "${YELLOW}Follow these steps to set the custom kernel: ${NC}"
    echo -e "${YELLOW}This will restart the Linux environment, so can be done after any other setup steps are complete.${NC}"
    echo -ne "${YELLOW}Press <Enter> to continue: ${NC}"
    read -r dummy < /dev/tty

  fi
fi