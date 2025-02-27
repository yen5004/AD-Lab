#!/bin/bash
# Helper script to assist in loading of recommended tools for AD Class Labs

# Check if the script is running with sudo privileges
if [ $(id -u) -ne 0 ]; then
  echo "This script requires sudo privileges. Exiting."
  exit 1
fi

# Relevant files will be stored here
echo "Clearing screen before we start..."
sleep 2 && clear

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Declare variables

# Create time stamp function
get_timestamp() {
  # Display date time as "01Jun2024_01:30:00-PM"
  date +"%d%b%Y_%H:%M:%S-%p"
}

project="AD-Lab" # Main folder for storage of downloads
folder="$HOME/$project" # Path to project folder where downloads will go
logg="$folder/install_log" # Log used to record where programs are stored
git_folder="$folder/GitHub" # Folder used to store GitHub repos
go_folder="$folder/Golang_folder"

# Check to see if the "project" folder exists in home directory and, if not, create one
if [ ! -d "$folder" ]; then
  echo "$project folder not found. Creating..."
  mkdir "$folder"
  echo "$project folder created successfully. - $(get_timestamp)" | tee -a $logg
else  
  echo "$project folder already exists. - $(get_timestamp)" | tee -a $logg
fi

# Create install_log
if [ ! -f "$logg" ]; then
    echo "install_log not found. Creating..."
    touch "$logg"
    chmod 644 "$logg" # Secure permissions for the install log
    echo "install_log created successfully. - $(get_timestamp)" | tee -a $logg
else
    echo "install_log already exists. - $(get_timestamp)" | tee -a $logg
fi

echo "Install log located at $logg - $(get_timestamp)" | tee -a $logg
echo "Install log created, begin tracking - $(get_timestamp)" | tee -a $logg

# Open a new terminal to monitor install_log
gnome-terminal --window --profile=default -- bash -c "watch -n .5 tail -f $logg"
sleep 3

# Update and upgrade options && Prompt user for action
echo "Select an option:"
echo "1. Perform sudo apt update and upgrade"
echo "2. Upgrade to kali-everything package"
echo "3. Just install tools"
read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Start machine update & upgrade - $(get_timestamp)" | tee -a $logg
        sudo apt update -y && sudo apt upgrade -y
        echo "Finish machine update & upgrade - $(get_timestamp)" | tee -a $logg
        ;;
    2)
        echo "Start machine update & full upgrade (kali-everything) - $(get_timestamp)" | tee -a $logg
        sudo apt update -y && sudo apt full-upgrade -y
        echo "Finish machine update & full upgrade (kali-everything) - $(get_timestamp)" | tee -a $logg
        ;;
    3)
        echo "Proceeding to install tools only - $(get_timestamp)" | tee -a $logg
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# APT installs:
echo "Begin APT installs..." | tee -a $logg

# Function to get the version of the tool dynamically
get_tool_version() {
    command -v $1 >/dev/null 2>&1 || { echo "Tool $1 not found"; return; }

    version=$($1 --version 2>/dev/null || $1 -v 2>/dev/null || $1 version 2>/dev/null || echo "Version info not available")
    echo "$version"
}

# Function to install apt tools
function install_apt_tools() {
    echo "Starting install of apt tools"
    for tool in $@; do
        if ! dpkg -l | grep -q "^ii $tool"; then
            echo "$tool is not installed. Installing..."
            if sudo apt install -y "$tool"; then
                echo "Installed apt $tool - $(get_timestamp)" | tee -a $logg
                tool_version=$(get_tool_version $tool)
                echo "Version of $tool: $tool_version - $(get_timestamp)" | tee -a $logg
            else
                echo "Failed to install apt $tool - $(get_timestamp)" | tee -a $logg
            fi
        else
            echo "Tool $tool is already installed. $(get_timestamp)" | tee -a $logg
            tool_version=$(get_tool_version $tool)
            echo "Version of $tool: $tool_version - $(get_timestamp)" | tee -a $logg
        fi
    done
}

# List out tools for apt install below
install_apt_tools wget cowsay htop freerdp2-x11 crackmapexec neo4j bloodhound krb5-user libpam-krb5 libpam-ccreds hashcat cherrytree chisel impacket-scripts evil-winrm python3-impacket pipx responder unzip python3-pip

echo "Finished APT installs..." | tee -a $logg

# Check to see if "gitlab" folder exists in project directory and if not creates one
# Create GitHub folder for downloads:
if [ ! -d "$git_folder" ]; then
  echo "$git_folder folder not found. Creating..."
  mkdir "$git_folder"
  echo "$git_folder folder created successfully. - $(get_timestamp)" | tee -a $logg
else  
  echo "$git_folder folder already exists" | tee -a $logg
fi

# Clone and install GitHub repos:
repo_urls=(
"https://github.com/itm4n/PrivescCheck.git"
"https://github.com/peass-ng/PEASS-ng.git"
"https://github.com/MWR-CyberSec/PXEThief.git"
"https://github.com/SnaffCon/Snaffler.git"
"https://github.com/sc0tfree/updog.git"
"https://github.com/yen5004/Seatbelt.git"
"https://github.com/yen5004/uptux.git"
"https://github.com/yen5004/vim-cheat-sheet.git"
"https://github.com/yen5004/LaZagne.git"
"https://github.com/yen5004/pingr.git"
"https://github.com/login-securite/DonPAPI.git"
"https://github.com/fortra/impacket.git"
"https://github.com/SpecterOps/BloodHound.git"
"https://github.com/BloodHoundAD/SharpHound"
"https://github.com/PowerShellMafia/PowerSploit.git"
"https://github.com/gentilkiwi/mimikatz.git"
"https://github.com/OmarFawaz/Invoke-Mimikatz.ps1-Version-2.1.1.git"
"https://github.com/clymb3r/PowerShell.git"
"https://github.com/g4uss47/Invoke-Mimikatz.git"
"https://github.com/dirkjanm/BloodHound.py.git"
"https://github.com/nidem/kerberoast.git"
"https://github.com/yen5004/BloodHound-Legacy.git"
"https://github.com/dirkjanm/mitm6.git"
"https://github.com/FSecureLABS/incognito.git"
)

# Clone repositories
for repo_url in "${repo_urls[@]}"; do
  repo_name=$(basename "$repo_url" .git) # Extract repo name from URL
  if [ ! -d "$git_folder/$repo_name" ]; then
    echo "Cloning $repo_name from $repo_url... - $(get_timestamp)" | tee -a $logg
    git clone "$repo_url" "$git_folder/$repo_name" || { echo "Failed to clone $repo_name"; exit 1; }
  else
    echo "Repo $repo_name already cloned at $git_folder/$repo_name. - $(get_timestamp)" | tee -a $logg
  fi 
done

# Install kerbrute
echo "Installing kerbrute..."
kerbrute_url="https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64"
kerbrute_folder="$git_folder/kerbrute"
mkdir -p "$kerbrute_folder"
cd "$kerbrute_folder"
wget "$kerbrute_url" -O kerbrute
chmod +x kerbrute
sudo ln -s "$kerbrute_folder/kerbrute" /usr/local/bin/kerbrute
kerbrute --version | tee -a $logg
echo "kerbrute installation completed - $(get_timestamp)" | tee -a $logg

# Install Python tools
echo "Installing Python tools..."
pip3 install updog || { echo "Failed to install updog"; exit 1; }
echo "Installed updog - $(get_timestamp)" | tee -a $logg

cd "$git_folder/LaZagne"
pip3 install -r requirements.txt || { echo "Failed to install LaZagne dependencies"; exit 1; }
echo "Installed LaZagne - $(get_timestamp)" | tee -a $logg

sudo python3 -m pipx install donpapi || { echo "Failed to install donpapi"; exit 1; }
echo "Installed donpapi - $(get_timestamp)" | tee -a $logg

sudo python3 -m pipx install impacket || { echo "Failed to install impacket"; exit 1; }
echo "Installed impacket - $(get_timestamp)" | tee -a $logg

# Download and extract PsTools
pstools_url="https://download.sysinternals.com/files/PSTools.zip"
pstools_folder="$folder/PSTools"
mkdir -p "$pstools_folder"
cd "$pstools_folder"
wget "$pstools_url" -O PSTools.zip
unzip PSTools.zip
echo "PsTools download and extraction completed!" | tee -a $logg

# Download SharpHound.exe
sharphound_url="https://github.com/SpecterOps/SharpHound/releases/latest/download/SharpHound.exe"
sharphound_folder="$git_folder/SharpHound_exe"
mkdir -p "$sharphound_folder"
cd "$sharphound_folder"
wget "$sharphound_url" -O SharpHound.exe
echo "SharpHound.exe download completed!" | tee -a $logg

# Install mitm6
mitm6_repo="https://github.com/dirkjanm/mitm6.git"
mitm6_folder="$git_folder/mitm6"
cd "$mitm6_folder"
pip3 install -r requirements.txt || { echo "Failed to install mitm6 dependencies"; exit 1; }
echo "mitm6 installation completed!" | tee -a $logg

# Done!
echo "All tools installed successfully - $(get_timestamp)" | tee -a $logg
