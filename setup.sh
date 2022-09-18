#!/bin/bash
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$(wget -qO- https://raw.githubusercontent.com/vhsec/izin/main/ip.txt | grep $MYIP )
if [ "$MYIP" = "$IZIN" ]; then
echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
echo -e "${NC}${RED}Permission Denied!${NC}";
echo -e "${NC}${LIGHT}Please Contact Admin!!"
echo -e "${NC}${LIGHT}Facebook : nothing"
echo -e "${NC}${LIGHT}WhatsApp : nothing"
echo -e "${NC}${LIGHT}Telegram : nothing"
exit 0
fi
#Install pkg
apt update
apt install wget dropbear python2 squid -y
#copy depend
mkdir /etc/vhsec
cp ws/ws /etc/vhsec/ws
cp ws/ws.service /etc/systemd/system/ws.service
cp ws/badvpn /etc/vhsec/badvpn
systemctl daemon-reload
systemctl enable ws
systemctl restart ws