#!/bin/bash

## Only enable sudo 
sudo echo ""

if [ "x$1" != "x" ] && [ "x$2" != "x" ]; then
  AD_DOMAIN=$1
  AD_USER=$2
else
  read -p "DOMAIN [GERU] => " IN_DOMAIN
  read -p "DOMAIN USER [$1] => " IN_DOMAIN_USER
  if [ "x$IN_DOMAIN" == "x" ]; then
    AD_DOMAIN="GERU"
  else
    AD_DOMAIN=$IN_DOMAIN
  fi
  if [ "x$IN_DOMAIN_USER" == "x" ] && [ "x$1" == "x" ]; then
    echo "Usuário invalido"
    exit 1
  else
    if [ "x$IN_DOMAIN_USER" == "x" ] && [ "x$1" != "x" ]; then
      IN_DOMAIN_USER=$1
    fi
    AD_USER=$IN_DOMAIN_USER
  fi
fi

#AD_DOMAIN="GERU"
#AD_USER="gustavo"
AD_LOGIN="$AD_DOMAIN\\$AD_USER"
AD_UID=$(id -u $AD_LOGIN)
AD_GID=$(id -g $AD_LOGIN)
AD_HOMEDIR="/home/local/$AD_DOMAIN"
AD_USER_HOME="$AD_HOMEDIR/$AD_USER"

LOCAL_LOGIN=$USER
LOCAL_UID=$(id -u $LOCAL_LOGIN)
LOCAL_GID=$(id -g $LOCAL_LOGIN)
LOCAL_GROUPS=$(id -G $LOCAL_LOGIN | sed 's/\ /,/g')
LOCAL_HOME="/home/$LOCAL_LOGIN"
LOCAL_HOME_LOCK="/home/$LOCAL_LOGIN.LOCK"

echo ""
echo "==== AD Vars ===="
echo "AD_DOMAIN=$AD_DOMAIN"
echo "AD_USER=$AD_USER"
echo "AD_LOGIN=$AD_LOGIN"
echo "AD_UID=$AD_UID"
echo "AD_GID=$AD_GID"
echo "AD_HOMEDIR=$AD_HOMEDIR"
echo "AD_USER_HOME=$AD_USER_HOME"
echo ""
echo "==== Local Vars ===="
echo "LOCAL_LOGIN=$LOCAL_LOGIN"
echo "LOCAL_UID=$LOCAL_UID"
echo "LOCAL_GID=$LOCAL_GID"
echo "LOCAL_GROUPS=$LOCAL_GROUPS"
echo "LOCAL_HOME=$LOCAL_HOME"
echo ""

read -n 1 -p "Confirma as informações acima [y/N] => " IN_CONFIRM
echo -e "\n\n"
if [[ "$IN_CONFIRM" =~ [^yY] ]]; then
  exit 0
fi

if [ "x$USER" == "xroot" ] || [ "x$USER" == "x$AD_LOGIN" ] || [ "x$USER" == "x" ]; then
  echo "Execute o script com o usuário local com ou sem sudo"
  exit 1
fi

if [ "x$LOCAL_GROUPS" != "x" ] && [ "x$AD_LOGIN" != "x" ]; then 
  echo "Adicionando os grupos do usuário local ao usuário do AD"
  echo "sudo usermod -aG $LOCAL_GROUPS $AD_LOGIN"
  read -n 1 -p "Confirma as informações acima [y/N] => " IN_CONFIRM
  echo -e "\n\n"
  if [[ "$IN_CONFIRM" =~ [yY] ]]; then
    sudo usermod -aG $LOCAL_GROUPS $AD_LOGIN
  fi
fi

if [ -d $AD_USER_HOME ] && [ -d $LOCAL_HOME ] && [ ! -f $LOCAL_HOME_LOCK ]; then
  echo "Removendo a pasta do usuário do AD"
  echo "sudo rm $AD_USER_HOME"
  read -n 1 -p "Confirma as informações acima [y/N] => " IN_CONFIRM
  echo -e "\n\n"
  if [[ "$IN_CONFIRM" =~ [yY] ]]; then
    sudo rm -rf $AD_USER_HOME
  fi
fi

if [ ! -d $AD_USER_HOME ] && [ -d $LOCAL_HOME ] && [ ! -f $LOCAL_HOME_LOCK ]; then
  echo "Movendo a pasta do usuário local para o usuário do AD"
  echo "sudo mv $LOCAL_HOME $AD_USER_HOME"
  read -n 1 -p "Confirma as informações acima [y/N] => " IN_CONFIRM
  echo -e "\n\n"
  if [[ "$IN_CONFIRM" =~ [yY] ]]; then
    echo "lock" | sudo tee $LOCAL_HOME_LOCK
    sudo mkdir -p $AD_HOMEDIR
    sudo mv $LOCAL_HOME $AD_USER_HOME
  fi
fi

echo "Ajustando as permissões de usuário"
echo "sudo chown -R $AD_UID $AD_USER_HOME"
read -n 1 -p "Confirma as informações acima [y/N] => " IN_CONFIRM
echo -e "\n\n"
if [[ "$IN_CONFIRM" =~ [yY] ]]; then
  sudo chown -R $AD_UID $AD_USER_HOME
fi

echo "Ajustando as permissões de grupo"
echo "sudo chgrp -R $AD_GID $AD_USER_HOME"
read -n 1 -p "Confirma as informações acima [y/N] => " IN_CONFIRM
echo -e "\n\n"
if [[ "$IN_CONFIRM" =~ [yY] ]]; then
  sudo chgrp -R $AD_GID $AD_USER_HOME
fi
