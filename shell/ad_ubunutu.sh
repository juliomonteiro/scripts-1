#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Procedimento Linux 17.10
#Remover AVAHI-DAEMON
apt-get remove avahi-daemon -y

#Atualização do Sistema
apt-get update

#instala aplicações necessarias
apt-get install ssh vim resolvconf

#Permissão SUDO AOS USUARIOS DO DOMINIO
echo  '%SKYLAN\\linuxadmins  ALL=(ALL) ALL' >>/etc/sudoers

#Configurar o arquivo /etc/hosts
echo 192.168.11.111 skylan.local >> /etc/hosts
echo 192.168.11.111 skysrv-dc-001 >> /etc/hosts
echo 192.168.11.111 skysrv-dc-001.skylan.local >> /etc/hosts

#Atualizar Resolvconf
echo domain skylan.local >> /etc/resolvconf/resolv.conf.d/base
echo search skylan.local >> /etc/resolvconf/resolv.conf.d/base
echo nameserver 192.168.11.111 >> /etc/resolvconf/resolv.conf.d/base

echo domain skylan.local >> /etc/resolvconf/resolv.conf.d/head
echo search skylan.local >> /etc/resolvconf/resolv.conf.d/head
echo nameserver 192.168.11.111 >> /etc/resolvconf/resolv.conf.d/head

#Baixar PBIS:  https://github.com/BeyondTrust/pbis-open/releases/download/8.5.2/pbis-open-8.5.2.265.linux.x86_64.deb.sh
GET_ARCH=$(getconf LONG_BIT)
PBIS_OPEN="https://github.com/BeyondTrust/pbis-open/releases/download/8.5.2"
PBIS_FILE="pbis-open-8.5.2.265.linux.x86_64.deb.sh"

if [ "$GET_ARCH" -eq "32" ]; then
   PBIS_OPEN="https://github.com/BeyondTrust/pbis-open/releases/download/8.5.2"
   PBIS_FILE="pbis-open-8.5.2.265.linux.x86_64.deb.sh"
fi
cd /tmp/
wget -c $PBIS_OPEN/${PBIS_FILE}
chmod +x $PBIS_FILE
./$PBIS_FILE
#rm -f $PBIS_FILE

#Ingressar equipamento no AD
./opt/pbis/bin/domainjoin-cli join SKYLAN.LOCAL thiago
		
#Execute os Passos abaixo
sudo /opt/pbis/bin/config UserDomainPrefix SKYLAN.LOCAL
sudo /opt/pbis/bin/config AssumeDefaultDomain true
sudo /opt/pbis/bin/update-dns
sudo /opt/pbis/bin/ad-cache --delete-all

# Reinicar o computador 
shutdown now -r

#Faça Logoff e logue com usuario de  dominio  --- caso não consiga logar execute o passo 11
#Abra o terminal e use sudo su..  se funcionar está ok!!!