#!/bin/bash

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[0;35m"
RESET="\033[0m"

# Title Script
echo -e "${MAGENTA}"
cat << "EOF"

  /$$$$$$  /$$$$$$$  /$$$$$$$        /$$   /$$ /$$      /$$  /$$$$$$  /$$$$$$$         /$$$$$$   /$$$$$$   /$$$$$$  /$$   /$$
 /$$__  $$| $$__  $$| $$__  $$      | $$$ | $$| $$$    /$$$ /$$__  $$| $$__  $$       /$$__  $$ /$$__  $$ /$$__  $$| $$$ | $$
| $$  \ $$| $$  \ $$| $$  \ $$      | $$$$| $$| $$$$  /$$$$| $$  \ $$| $$  \ $$      | $$  \__/| $$  \__/| $$  \ $$| $$$$| $$
| $$$$$$$$| $$$$$$$/| $$$$$$$/      | $$ $$ $$| $$ $$/$$ $$| $$$$$$$$| $$$$$$$/      |  $$$$$$ | $$      | $$$$$$$$| $$ $$ $$
| $$__  $$| $$__  $$| $$____/       | $$  $$$$| $$  $$$| $$| $$__  $$| $$____/        \____  $$| $$      | $$__  $$| $$  $$$$
| $$  | $$| $$  \ $$| $$            | $$\  $$$| $$\  $ | $$| $$  | $$| $$             /$$  \ $$| $$    $$| $$  | $$| $$\  $$$
| $$  | $$| $$  | $$| $$            | $$ \  $$| $$ \/  | $$| $$  | $$| $$            |  $$$$$$/|  $$$$$$/| $$  | $$| $$ \  $$
|__/  |__/|__/  |__/|__/            |__/  \__/|__/     |__/|__/  |__/|__/             \______/  \______/ |__/  |__/|__/  \__/

					    arp-nmap-scan.sh - v1.0
                                       	     Autor -> Jorge Garrido
EOF
echo -e "${RESET}"

# CODE
# --------- Network interface to scan ---------
INTERFACE="eth0" # Replace with your active interface (use `ip a` to check)

# --------- Step 1: Discover active IPs in the local network using arp-scan ---------
# -I <interface>: specify the network interface
# --localnet: scan the local subnet
# grep -v "DUP:": remove duplicate responses
# awk: extract unique IPs only (first column)
# tr -d ' ': remove any whitespace
# Output is saved to a temporary file ips.txt
sudo arp-scan -I $INTERFACE --localnet | grep -v "DUP:" | awk '!v[$1]++ && /^[0-9]+\./ {print $1}' | tr -d ' ' > ips.txt

# --------- Step 2: Iterate through each IP and run a full port scan with nmap ---------
while read -r ip; do
	echo -e "${YELLOW}\n🔍 Scanning ports on $ip with nmap...${RESET}"

	# nmap options explained:
    	# -p-     → scan all 65535 ports
    	# -sS     → TCP SYN scan (stealthy and fast)
    	# -sC     → run default scripts
    	# -sV     → detect service versions
    	# --min-rate=5000 → set minimum packet send rate (faster)
    	# -n      → no DNS resolution
    	# -Pn     → skip host discovery (assumes host is up)
    	# -oN     → output results to file scan_<ip>.txt
	nmap -p- -sS -sC -sV --min-rate=5000 -n -Pn $ip -oN "scan_$ip.txt"

done < ips.txt
# --------- Step 3: Clean up temporary file ---------
rm ips.txt

# --------- Final message ---------
echo -e "${GREEN}\n✅ Scan completed successfully.${RESET}"
