#!/bin/bash
#Helper script to assist in loading of recommended tools for AD Class Labs

# Relevant files will be stored here
sudo ls # get sudo before we start
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
#logg="$folder/install_log" # Log used to record where programs are stored
logg="$folder" # Log used to record where programs are stored
git_folder="$folder/GitHub" # Folder used to store GitHub repos
go_folder="$folder/Golang_folder"

#check to see if the "project" folder exists in home directory and, if not create one
cd ~
if [ ! -d "$folder" ]; then
  echo "$project folder not found. Creating..."
  mkdir "$folder"
  echo "$project folder created successfully. - $(get_timestamp)" | tee -a $logg
  echo "$project folder located here: " ls -la | grep $folder
else  
  echo "$project folder already exists. - $(get_timestamp)" | tee -a $logg
fi

#change to the default folder
cd $folder

#create install_log
if [ ! -d "$folder/install_log" ]; then
    echo "install_log not found. Creating..."
    sudo touch "$folder/install_log"
    sudo chmod 777 "$folder/install_log" # install_log reffered to var name $logg
    echo "install_log created successfully. - $(get_timestamp)" | tee -a $logg
else
    echo "install_log folder already exists. - $(get_timestamp)" | tee -a $logg
fi

echo "Install log located at $folder/install_log - $(get_timestamp)" | tee -a $logg
echo "Install log created, begin tracking - $(get_timestamp)" | tee -a $logg

# Open a new terminal to monitor install_log
sudo apt install -y gnome-terminal
echo "Opening new terminal to monitor install_log..."
gnome-terminal --window --profile=AI -- bash -c "watch -n .5 tail -f $logg"
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
        ;;
esac

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo "        "  | tee -a $logg
echo "       1"  | tee -a $logg
echo "      111" | tee -a $logg
echo "     11111"| tee -a $logg
echo "      111" | tee -a $logg
echo "       1"  | tee -a $logg
echo "        "  | tee -a $logg
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# apt installs:
echo "Begin APT installs..." | tee -a $logg

cd $HOME
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

cd $HOME

# List out tools for apt install below
install_apt_tools wget cowsay htop freerdp2-x11 crackmapexec neo4j boodhound krb5-user libpam-krb5 libpam-ccreds hashcat cherrytree chisel impacket-scripts evil-winrm python3-impacket pipx responder unzip python3-pip



echo "Finished APT installs..." | tee -a $logg
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Check to see if "gitlab" folder exists in project directory and if not creates one
# Create github folder for downloads:

if [ ! -d "$git_folder" ]; then
  echo "$git_folder folder not found. Creating..."
  sudo mkdir "$git_folder" && sudo chmod 777 "$git_folder"
  echo "$git_folder folder created successfully. - $(get_timestamp)" | tee -a $logg
else  
  echo "$git_folder folder already exists" | tee -a $logg
fi

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

cd $git_folder
# Download the following gitlab repos:
repo_urls=(
# List of GitLab reps urls:
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

# Directory of where repos will be cloned:

echo "       ^"  | tee -a $logg
echo "      ^^^" | tee -a $logg
echo "     ^^^^^"| tee -a $logg
echo "      ^^^" | tee -a $logg
echo "       ^"  | tee -a $logg


for repo_url in "${repo_urls[@]}"; do
  repo_name=$(basename "$repo_url" .git) # Extract repo name from url
  if [ ! -d "$git_folder/$repo_name" ]; then # Check if directory already exists
  echo "Cloning $repo_name from $repo_url... - $(get_timestamp)" | tee -a $logg
  #sudo git clone "repo_url" "$git_folder/$repo_name" || { echo "Failed to clone $repo_name"; exit 1; } # Clone repo and handle errors
  sudo git clone "$repo_url" "$git_folder/$repo_name" || { echo "Failed to clone $repo_name"; exit 1; } # Clone repo and handle errors
  else
  	echo "Repo $repo_name already cloned at $git_folder/$repo_name. - $(get_timestamp)" | tee -a $logg
  fi 
done
cd ~

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Special Git installs:

# Download and install kerbrute
sudo mkdir -p "$git_folder/kerbrute"
cd "$git_folder/kerbrute"

# Download kerbrute from the GitHub release
wget https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute

# Make the binary executable
chmod +x kerbrute

# Create a symbolic link to make kerbrute accessible from anywhere
sudo ln -s /opt/kerbrute/kerbrute /usr/local/bin/kerbrute

# Verify installation
kerbrute --version
kerbrute --version | tee -a $logg
echo "kerbrute installation completed - $(get_timestamp)" | tee -a $logg



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Python installs

# Start python install of updog
cd $git_folder
pip3 install updog
echo "Installed updog - $(get_timestamp)" | tee -a $logg
cd $git_folder

# Start python install of LaZagne
cd $git_folder
cd LaZagne
echo "This is working directory: " pwd
pip3 install -r requirements.txt
echo "Installed LaZagne - $(get_timestamp)" | tee -a $logg
cd $git_folder

# Start python pipx install of donpapi
sudo python3 -m pipx install donpapi
echo "Installed donpapi - $(get_timestamp)" | tee -a $logg

# Start python pipx install of impacket
sudo python3 -m pipx install impacket
echo "Installed impacket - $(get_timestamp)" | tee -a $logg


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Download and extract PsTools
pstools_url="https://download.sysinternals.com/files/PSTools.zip"
pstools_folder="$folder/PSTools"

{
    echo "$(get_timestamp) - Starting PsTools download..." | tee -a $logg

    # Create a directory for PsTools
    sudo mkdir -p "$pstools_folder" || { echo "Failed to create directory" | tee -a $logg; exit 1; }
    cd "$pstools_folder" || { echo "Failed to navigate to directory" | tee -a $logg; exit 1; }

    # Download PsTools ZIP
    wget "$pstools_url" -O PSTools.zip || { echo "Failed to download PsTools" | tee -a $logg; exit 1; }

    # Extract PsTools ZIP
    unzip PSTools.zip || { echo "Failed to extract PsTools" | tee -a $logg; exit 1; }

    echo "$(get_timestamp) - PsTools download and extraction completed!" | tee -a $logg
} 2>&1 | tee -a $logg


# Download SharpHound.exe
sharphound_url="https://github.com/SpecterOps/SharpHound/releases/latest/download/SharpHound.exe"
sharphound_folder="$git_folder/SharpHound_exe"

{
    echo "$(get_timestamp) - Starting SharpHound.exe download..." | tee -a $logg

    # Create a directory for SharpHound
    sudo mkdir -p "$sharphound_folder" || { echo "Failed to create directory" | tee -a $logg; exit 1; }
    cd "$sharphound_folder" || { echo "Failed to navigate to directory" | tee -a $logg; exit 1; }

    # Download SharpHound.exe
    wget "$sharphound_url" -O SharpHound.exe || { echo "Failed to download SharpHound.exe" | tee -a $logg; exit 1; }

    echo "$(get_timestamp) - SharpHound.exe download completed!" | tee -a $logg
} 2>&1 | tee -a $logg

# Clone and install mitm6
mitm6_repo="https://github.com/dirkjanm/mitm6.git"
mitm6_folder="$git_folder/mitm6"

{
    echo "$(get_timestamp) - Starting mitm6 installation..." | tee -a $logg

    # Clone the mitm6 repository
    cd "$mitm6_folder" || { echo "Failed to navigate to mitm6 directory" | tee -a $logg; exit 1; }

    # Install mitm6 dependencies
    pip3 install -r requirements.txt || { echo "Failed to install mitm6 dependencies" | tee -a $logg; exit 1; }

    # Install mitm6
    sudo python3 setup.py install || { echo "Failed to install mitm6" | tee -a $logg; exit 1; }

    echo "$(get_timestamp) - mitm6 installation completed!" | tee -a $logg
} 2>&1 | tee -a 

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

########################################
