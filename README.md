# AD-Lab

This repository contains a collection of scripts and tools to assist in Active Directory (AD) Lab setups and penetration testing. The primary focus of this project is to simplify the installation and setup of recommended tools for AD Class Labs.

## Installation Guide for `tool_installer.sh`

The `tool_installer.sh` script automates the installation of various tools commonly used in Active Directory penetration testing. It requires **sudo** privileges to run, and will guide you through updating your system and installing a set of predefined tools.

### Prerequisites

Before running the `tool_installer.sh` script, ensure you have the following:

- A **Linux** machine (Ubuntu or Kali recommended).
- **sudo** privileges on the system.
- Basic knowledge of using the terminal.

### Step-by-Step Installation

Follow these steps to use the `tool_installer.sh` script:

#### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/yen5004/AD-Lab.git
cd AD-Lab
```

#### 2. Make the Script Executable

Ensure that the `tool_installer.sh` script is executable. Run the following command to set the proper permissions:

```bash
chmod +x tool_installer.sh
```

#### 3. Run the Script with Sudo Privileges

Now, you can run the script. Since the script requires **sudo** privileges, execute it using `sudo`:

```bash
sudo ./tool_installer.sh
```

#### 4. Follow the Interactive Prompts

Once you run the script, it will prompt you with options to choose from. Here's what you can expect:

- **Option 1**: Perform an `apt update` and upgrade the system.
- **Option 2**: Upgrade to the `kali-everything` package.
- **Option 3**: Skip the system upgrade and proceed with tool installation only.

Use the arrow keys to select one of the options and press **Enter**.

#### 5. Watch the Installation Progress

The script will display logs of the installation process in the terminal. You can follow along as it installs and configures the necessary tools.

Additionally, the script will automatically open a new terminal window to monitor the `install_log` in real-time.

#### 6. Completed Installation

Once the script completes the installation, it will notify you, and you can start using the installed tools.

---

### Notes:

- The script installs a set of penetration testing tools, including `bloodhound`, `krb5-user`, `crackmapexec`, and others.
- It also clones several GitHub repositories that contain important tools for AD-related security testing.
- Logs of the installation are stored in the `install_log` file located within the project folder.

### Troubleshooting

- **Permission Denied**: If you receive a permission error, make sure you have the necessary sudo privileges and try running the script with `sudo`.
- **Missing Dependencies**: If a specific tool doesn't install properly, ensure that your system's package manager (`apt`) is up-to-date.

