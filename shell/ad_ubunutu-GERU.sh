#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Procedimento Linux 17.10

#Remover AVAHI-DAEMON
apt-get remove avahi-daemon --force-yes

#Atualização do Sistema
apt-get update

#instala aplicações necessarias
apt-get install ssh vim resolvconf

#Permissão SUDO AOS USUARIOS DO DOMINIO
echo  '%GERU\\userlinux  ALL=(ALL) ALL' >> /etc/sudoers

#Configurar o arquivo /etc/hosts
echo  172.155.10.185 geru.local >> /etc/hosts
echo  172.155.10.185 ger-srv-dc-001 >> /etc/hosts
echo  172.155.10.185 ger-srv-dc-001.geru.local >> /etc/hosts

#Atualizar Resolvconf
echo  domain geru.local >> /etc/resolvconf/resolv.conf.d/base
echo  search geru.local >> /etc/resolvconf/resolv.conf.d/base
echo  nameserver 172.155.10.185 >> /etc/resolvconf/resolv.conf.d/base

echo  domain geru.local >> /etc/resolvconf/resolv.conf.d/head
echo	search geru.local >> /etc/resolvconf/resolv.conf.d/head
echo	nameserver 172.155.10.185 >> /etc/resolvconf/resolv.conf.d/head

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

# Reinicar o computador 
shutdown now -r

#Ingressar equipamento no AD
./opt/pbis/bin/domainjoin-cli join GERU.LOCAL suporte.skylan
		
#Execute os Passos abaixo
sudo /opt/pbis/bin/config UserDomainPrefix GERU.LOCAL
sudo /opt/pbis/bin/config AssumeDefaultDomain true
sudo /opt/pbis/bin/update-dns
sudo /opt/pbis/bin/ad-cache --delete-all

#Faça Logoff e logue com usuario de  dominio  --- caso não consiga logar execute o passo 11
#Abra o terminal e use sudo su..  se funcionar está ok!!!