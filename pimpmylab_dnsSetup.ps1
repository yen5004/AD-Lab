ertainly! Below is an updated version of the script with a new section added to write the IP addresses and settings for each of the three machines (assuming these are Windows VMs) to a log file. It will also suggest IP settings for the Kali attack VM based on your existing network configuration.

Key Changes:
Logging IP Addresses and Settings: A new function Log-IPSettings is added to capture the IP addresses and related settings for each machine (VM) and write this information to a text file.
IP Setting Suggestions for Kali VM: Based on the existing network setup, the script will suggest an appropriate IP address for the Kali attack VM.
Updated Script:

Key Features of the Update:
Logging of IP Settings:

The Log-IPSettings function retrieves the IP settings of the network interfaces on the three Windows VMs and logs them to C:\LabSetup\lab_ip_settings.txt.
It writes the IP, subnet mask, and gateway for each of the VMs and suggests an IP address for the Kali VM (e.g., VM1.IP + .250).
Suggested Kali IP:

The IP address suggestion for the Kali VM is derived from the first three octets of the first VM's IP address, with .250 as the suggested last octet (this can be adjusted based on your desired IP range).
Offline Operation:

The script does not require an internet connection, as requested.
Running the Script:
Run this script on each of your VMs with administrative privileges.
Check the log file at C:\LabSetup\lab_ip_settings.txt to see the IP configurations and suggested IP for the Kali VM.
Let me know if you need further adjustments!

```
# --- Begin Logging Setup ---
function Log-Message {
    param (
        [string]$message,
        [string]$logFile = "C:\LabSetup\lab_setup_log.txt"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logEntry
}

# --- Begin IP Logging Function ---
function Log-IPSettings {
    param (
        [string]$logFile = "C:\LabSetup\lab_ip_settings.txt"
    )

    try {
        # Collect IP and network settings for each of the 3 Windows VMs
        $vm1 = Get-NetIPAddress -InterfaceAlias "Ethernet 1" | Select-Object -First 1
        $vm2 = Get-NetIPAddress -InterfaceAlias "Ethernet 2" | Select-Object -First 1
        $vm3 = Get-NetIPAddress -InterfaceAlias "Ethernet 3" | Select-Object -First 1

        # Write the IP and settings to the log file
        $vm1Info = "VM1 IP: $($vm1.IPAddress) - Subnet: $($vm1.PrefixLength) - Gateway: $($vm1.DefaultGateway)"
        $vm2Info = "VM2 IP: $($vm2.IPAddress) - Subnet: $($vm2.PrefixLength) - Gateway: $($vm2.DefaultGateway)"
        $vm3Info = "VM3 IP: $($vm3.IPAddress) - Subnet: $($vm3.PrefixLength) - Gateway: $($vm3.DefaultGateway)"

        # Write to log
        Add-Content -Path $logFile -Value $vm1Info
        Add-Content -Path $logFile -Value $vm2Info
        Add-Content -Path $logFile -Value $vm3Info

        # Suggest IP for Kali VM (Assuming the Kali VM is part of the same network range)
        $KaliSuggestedIP = "$($vm1.IPAddress.Split('.')[0..2] -join '.')".PadRight(15) + ".250"
        $suggestionMessage = "Suggested IP for Kali VM: $KaliSuggestedIP (Make sure it's in the same subnet as VM1)"
        Add-Content -Path $logFile -Value $suggestionMessage

        Log-Message "IP settings for VM1, VM2, VM3, and Kali VM suggestion written to file successfully."

    } catch {
        Log-Message "Failed to log IP settings: $_"
    }
}

# --- Begin Antivirus Disable Function ---
function Disable-Antivirus {
    try {
        # Disable Windows Defender Antivirus (if applicable)
        Set-MpPreference -DisableRealtimeMonitoring $true
        Log-Message "Antivirus (Windows Defender) disabled successfully."
    } catch {
        Log-Message "Failed to disable antivirus: $_"
    }
}

# --- Begin Ping and Networking Configuration ---
function Enable-Ping {
    try {
        # Allow ICMP (ping) from all machines
        New-NetFirewallRule -DisplayName "Allow ICMP Echo Request" -Protocol ICMPv4 -Direction Inbound -Action Allow
        Log-Message "Ping (ICMP) allowed successfully."
    } catch {
        Log-Message "Failed to enable ping: $_"
    }
}

function Set-Networking {
    try {
        # Get the current network adapter
        $adapter = Get-CimInstance -Class Win32_NetworkAdapter -Property NetConnectionID, NetConnectionStatus | 
                   Where-Object { $_.NetConnectionStatus -eq 2 } | 
                   Select-Object -Property NetConnectionID -ExpandProperty NetConnectionID

        # Set static IP and DNS
        $IPAddress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
        $IPByte = $IPAddress.Split(".")
        $StaticIP = ($IPByte[0] + "." + $IPByte[1] + "." + $IPByte[2] + ".250")
        $StaticGateway = ($IPByte[0] + "." + $IPByte[1] + "." + $IPByte[2] + ".1")
        $StaticMask = "255.255.255.0"

        # Set static IP address
        netsh interface ipv4 set address name="$adapter" static $StaticIP $StaticMask $StaticGateway
        Log-Message "Static IP set to $StaticIP with gateway $StaticGateway."

        # Set DNS to 127.0.0.1 for the local domain controller
        netsh interface ipv4 set dnsservers name="$adapter" static 127.0.0.1
        Log-Message "DNS set to 127.0.0.1."

    } catch {
        Log-Message "Failed to configure networking: $_"
    }
}

# --- Begin Miscellaneous Configurations ---
function Set-ScreenLockTimeout {
    try {
        # Set screen lock timeout to 10 minutes
        $key = "HKCU:\Control Panel\Desktop"
        Set-ItemProperty -Path $key -Name "ScreenSaveTimeOut" -Value "600"
        Log-Message "Screen lock timeout set to 10 minutes."
    } catch {
        Log-Message "Failed to set screen lock timeout: $_"
    }
}

function Set-ScreenSaver {
    try {
        # Enable screen saver and set to 10 minutes
        $key = "HKCU:\Control Panel\Desktop"
        Set-ItemProperty -Path $key -Name "ScreenSaveActive" -Value 1
        Set-ItemProperty -Path $key -Name "ScreenSaveTimeOut" -Value 600
        Log-Message "Screen saver enabled and set to 10 minutes."
    } catch {
        Log-Message "Failed to enable screen saver: $_"
    }
}

function Set-DarkMode {
    try {
        # Set system to Dark Mode
        $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty -Path $key -Name "AppsUseLightTheme" -Value 0
        Set-ItemProperty -Path $key -Name "SystemUsesLightTheme" -Value 0
        Log-Message "Dark mode enabled successfully."
    } catch {
        Log-Message "Failed to set dark mode: $_"
    }
}

# --- Begin Workstation DNS Fix Function ---
function Fix-WorkstationDNS {
    try {
        # Get the domain controller DNS (from hardcoded IP or preset)
        $DCDNS = "192.168.1.1"  # Example, replace with actual DC IP

        # Get network adapter and disable power management
        $adapter = Get-CimInstance -Class Win32_NetworkAdapter -Property NetConnectionID, NetConnectionStatus |
                   Where-Object { $_.NetConnectionStatus -eq 2 } |
                   Select-Object -Property NetConnectionID -ExpandProperty NetConnectionID

        Disable-NetAdapterPowerManagement -Name "$adapter"
        Log-Message "Power management disabled for $adapter."

        # Set DNS for IPv4
        netsh interface ipv4 set dnsservers name="$adapter" static $DCDNS
        Log-Message "Workstation DNS set to $DCDNS."

        # Set DNS for IPv6 to DHCP
        netsh interface ipv6 set dnsservers "$adapter" dhcp
        Log-Message "Workstation IPv6 DNS set to DHCP."

    } catch {
        Log-Message "Failed to configure workstation DNS: $_"
    }
}

# --- Main Setup Function ---
function LabSetup {
    try {
        Log-Message "Starting lab setup..."

        # Disable Antivirus
        Disable-Antivirus

        # Enable Ping (ICMP)
        Enable-Ping

        # Set Networking (IP, DNS)
        Set-Networking

        # Set Screen Lock Timeout and Screen Saver
        Set-ScreenLockTimeout
        Set-ScreenSaver

        # Set Dark Mode
        Set-DarkMode

        # Fix Workstation DNS
        Fix-WorkstationDNS

        # Log IP settings and suggest Kali VM IP
        Log-IPSettings

        Log-Message "Lab setup completed successfully."

    } catch {
        Log-Message "Lab setup failed: $_"
    }
}

# Run Lab Setup
LabSetup

```
