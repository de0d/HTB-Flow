#!/usr/bin/env bash

echo "checking for active vpn connection"
ifconfig tun0 > vpn.txt
FILENAME=vpn.txt
if grep -q . "${FILENAME}"; then
    echo "VPN is connected!"
    rm vpn.txt
else
    echo "File is empty"
    rm vpn.txt
    exit
fi
echo "Welcome!"
cat WelcomeBanner.txt
echo "Welcome! Please enter the ip address you are trying to hack:"
read varname
echo $varname > ipaddress.txt
echo "Working on it"
nmap -sC -sV -Pn -iL ipaddress.txt > nmap.txt
rm ipaddress.txt
gobuster dir -u http://$varname/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt -t 100 > gobust.txt
cat nmap.txt | grep '[0-65535]/tcp' > nmap_filtered.txt
echo "The following ports are open and available. Now dont accidently wear your cum sock today"
cat gobust.txt
cat nmap_filtered.txt
rm nmap_filtered.txt
rm nmap.txt
rm gobust.txt
