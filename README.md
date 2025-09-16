
# cros-base

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