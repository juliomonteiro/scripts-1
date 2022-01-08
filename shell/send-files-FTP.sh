#!/bin/sh
HOST="187.35.147.58 2128"
USER="larjesus"
PASSWORD="J35u5@#$"

ftp -inv $HOST <<EOF
user $USER $PASSWORD
cd /path/to/file
mput glpi*.*
bye
EOF