
# cros-android

**cros-base** is a template repository for initializing and configuring a ChromeOS development environment. It provides a standardized structure, essential setup scripts, and configuration files that can be reused across multiple projects.

## Purpose
This repository helps automate the setup of a ChromeOS Linux environment by:
- Installing essential packages (e.g., git, git-lfs)
- Configuring global git settings (username, email)
- Providing a base structure for downstream projects
- Enabling easy updates by tracking this repo as an upstream remote

## Repository Structure

- `.setup/` — Contains setup scripts:
  - `setup.sh`: Main entry point for environment setup and repo initialization
  - `scripts/000-init.sh`: Installs required packages and configures git
- `.github/` — Contains repository configuration files:
  - `CODEOWNERS`: Declares repository ownership
- `README.md` — This documentation file

## Usage

### Quick Start
1. Open the ChromeOS Linux terminal.
2. Run the following command to download and execute the setup script:
   ```bash
   bash <(curl -sS https://raw.githubusercontent.com/neilgfoster/cros-base/main/.setup/setup.sh) -o=neilgfoster -r=cros-base
   ```
   - Replace `-o=neilgfoster` and `-r=cros-base` with your organization and repository names if using as a template.

### What the Setup Script Does
- Clones the repository into the specified organization folder
- Pulls the latest changes
- Installs required packages
- Prompts for git configuration if not already set
- Executes all numbered scripts in `.setup/scripts/` for further initialization

## Updating Downstream Projects
You can add this repository as an upstream remote in your downstream projects to easily merge updates and maintain consistency.

## Maintainers
- Repository owner: @neilgfoster (see `.github/CODEOWNERS`)

---
For questions or improvements, please open an issue or pull request.

## Manual Steps

### Prepare Kernel Build Configuration
Source: https://gist.github.com/supechicken/e6bb13e2db86a74e831f907805aed078#step-1-recompile-kernel-with-binder-ipc-support

In order to configure the kernel to support Binder IPC, you must manually enable it in the kernel configuration. Follow these steps:

1) Open a new linux terminal
2) Ensure you are in the root of the kernel source directory
3) Run the following command to open the kernel configuration menu:

```bash
make LLVM=1 LLVM_IAS=1 menuconfig
```

4) Follow the menu options below to enable Binder IPC support:

```
Device Drivers                          ---> (Space to enter)
  Android (in the bottom of page)       ---> (Space to enter)
    Android Binder devices              ---> (Space to enter)
      Android Binder IPC Driver         ---> (Space to select)
      [*]  Android Binderfs filesystem  ---> (Space to select)
```

5) Save and exit the configuration menu

### Boot With Custom Kernel
Source: https://gist.github.com/supechicken/e6bb13e2db86a74e831f907805aed078#step-3-boot-linux-vm-with-custom-kernel_

Once you have built the kernel and copied the image to your ChromeOS filesystem, you can
configure the Linux environment to use this custom kernel.

1) Press Ctrl+Alt+T to bring up a crosh window
2) Shut down Linux VM:

```bash
vmc stop termina
```
3) Boot Linux VM with custom kernel

```
vmc start termina --enable-gpu --kernel /home/chronos/user/MyFiles/<PATH TO KERNEL IMAGE>
```

4) If successful, your terminal in Crosh should look like:

```shell
(termina) chronos@localhost ~ $
```

5) Run these [automated scripts](https://github.com/supechicken/ChromeOS-Waydroid-Installer) to install Waydroid and Android image:

```bash
curl -L https://github.com/supechicken/ChromeOS-Waydroid-Installer/raw/refs/heads/main/installer/01-setup_lxd.sh | bash -eu
```
