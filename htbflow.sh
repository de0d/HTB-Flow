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
echo "Welcome! Please enter the ip address you would like enumerated:"
read varname
ip=$varname
if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
  for i in 1 2 3 4; do
    if [ $(echo "$ip" | cut -d. -f$i) -gt 255 ]; then
      echo "fail ($ip)"
      exit 1
    fi
  done
  echo "success ($ip)"
else
  echo "fail ($ip)"
  exit 1
fi
echo $varname
echo "Working on it"
nmap -sC -sV -Pn -p- $varname -oN $varname.txt -oX $varname.xml
gobuster dir -u http://$varname/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt -t 100 > gobust.txt

clear

echo "The following domains are available."
cat gobust.txt
echo "if gobuster is giving you an error you may need to edit your /etc/hosts file"
echo "

The following ports are available with the following services. Thank you for choosing LunchBox"
cat $varname.txt | grep '[0-65535]/tcp' > nmap_filtered.txt
cat nmap_filtered.txt


echo "

Would you like to search for vulnerabilities in search results?
y/n:"
read yesno
if expr $yesno : '[y]'; then
        searchsploit --nmap $varname.xml --path
else
        echo "hope you enjoyed using the script please make any suggestions and tell
                me any errors at https://github.com/LunchBox6996/HTB-flow"
fi

rm $varname.xml
rm gobust.txt
rm $varname.txt
rm nmap_filtered.txt
