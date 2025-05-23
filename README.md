# 🔎 Network and Port Scanner with `arp-scan` + `nmap`

This Bash script automates local network device discovery using `arp-scan`, and performs a full port scan on each detected IP using `nmap`.

---

## 🧾 What does this script do?

1. Scans the local network interface (`eth0` by default) with `arp-scan`.
2. Filters and stores **unique IP addresses** into a file called `ips.txt`.
3. Iterates through each IP and runs a **fast, aggressive port scan** using `nmap` with:
   - All TCP ports (`-p-`)
   - SYN scan (`-sS`)
   - Default scripts and version detection (`-sC -sV`)
   - High-speed scan (`--min-rate=5000`)
4. Saves results for each host in separate output files: `scan_<IP>.txt`
5. Deletes `ips.txt` after processing is complete.
6. Prints progress messages using colors and emojis.

---

## ⚙️ Requirements

- Linux with Bash
- `arp-scan`
- `nmap`
- `sudo` privileges

### Install required tools:

```bash
sudo apt update
sudo apt install arp-scan nmap
