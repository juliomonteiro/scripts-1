#!/bin/bash
#Assign existing hostname to $hostn
hostn=$(cat /etc/hostname)

#Display existing hostname
echo "O nome do host existente é $hostn"

#Ask for new hostname $newhost
echo "Digite o novo nome do host: "
read newhost

#change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$hostn/$newhost/g" /etc/hosts
sudo sed -i "s/$hostn/$newhost/g" /etc/hostname

#display new hostname
echo "Seu novo nome de host é $newhost"

#Press a key to reboot
read -s -n 1 -p "Pressione qualquer tecla para reiniciar"
sudo reboot