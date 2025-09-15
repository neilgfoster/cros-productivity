
# cros-productivity

**cros-productivity** is a setup and initialization utility for ChromeOS Linux environments, focused on automating the installation of essential productivity tools and configuration. It provides scripts to quickly set up git, git-lfs, LibreOffice, and global git settings, making it easy to bootstrap a productive workspace.


## Purpose
This repository automates the setup of a ChromeOS Linux environment by:
- Installing essential packages (git, git-lfs, LibreOffice)
- Configuring global git settings (username, email)
- Providing a base structure for productivity-focused downstream projects
- Enabling easy updates by tracking this repo as an upstream remote


## Repository Structure

- `.setup/` — Contains setup scripts:
	- `setup.sh`: Main entry point for environment setup and repo initialization
	- `scripts/000-init.sh`: Installs required packages and configures git
	- `scripts/001-libreoffice.sh`: Installs LibreOffice productivity suite
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
- Installs required packages (git, git-lfs, LibreOffice)
- Prompts for git configuration if not already set
- Executes all numbered scripts in `.setup/scripts/` for further initialization


## Updating Downstream Projects
You can add this repository as an upstream remote in your downstream projects to easily merge updates and maintain consistency.

## Maintainers
- Repository owner: @neilgfoster (see `.github/CODEOWNERS`)

---
For questions or improvements, please open an issue or pull request.