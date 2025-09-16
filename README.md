
# cros-productivity


**cros-productivity** is an interactive setup utility for ChromeOS Linux environments, automating installation and configuration of essential productivity tools. It provides scripts to quickly set up git, git-lfs, OneDrive (with selective sync), LibreOffice (with dark mode tweaks), and global git settings, making it easy to bootstrap a productive workspace tailored to your needs.


## Purpose

This repository automates the setup of a ChromeOS Linux environment by:
- Installing essential packages (git, git-lfs, LibreOffice)
- Configuring global git settings (username, email)
- Setting up OneDrive with user prompts for target directory, folders to sync, and sync interval
- Installing LibreOffice and forcing dark mode in launchers
- Providing a base structure for productivity-focused downstream projects
- Enabling easy updates by tracking this repo as an upstream remote


## Repository Structure


- `.setup/` — Contains setup scripts:
	- `setup.sh`: Main entry point for interactive environment setup and repo initialization
	- `scripts/000-init.sh`: Installs git, git-lfs, and configures global git settings
	- `scripts/001-onedrive.sh`: Installs and configures OneDrive with user prompts for target directory, folders to sync, and sync interval
	- `scripts/002-libreoffice.sh`: Installs LibreOffice and forces dark mode in desktop launchers
- `.github/` — Contains repository configuration files:
	- `CODEOWNERS`: Declares repository ownership
- `README.md` — This documentation file


## Usage


### Quick Start
1. Open the ChromeOS Linux terminal.
2. Run the following command to download and execute the setup script:
	```bash
	bash <(curl -sS https://raw.githubusercontent.com/neilgfoster/cros-productivity/main/.setup/setup.sh) -o=neilgfoster -r=cros-productivity
	```
	- Replace `-o=neilgfoster` and `-r=cros-productivity` with your organization and repository names if using as a template.

### What the Setup Script Does
- Clones the repository into the specified organization folder
- Pulls the latest changes
- Installs required packages (git, git-lfs, LibreOffice, OneDrive)
- Prompts for git configuration if not already set
- Prompts for OneDrive setup: target directory, folders to sync, and sync interval
- Prompts for LibreOffice installation and applies dark mode tweaks

### Interactive Setup
Each step of the setup is interactive, prompting you for choices and configuration details. You can skip components you do not need, and customize your environment for productivity on ChromeOS Linux.
- Executes all numbered scripts in `.setup/scripts/` for further initialization


## Updating Downstream Projects
You can add this repository as an upstream remote in your downstream projects to easily merge updates and maintain consistency.

## Maintainers
- Repository owner: @neilgfoster (see `.github/CODEOWNERS`)

---
For questions or improvements, please open an issue or pull request.