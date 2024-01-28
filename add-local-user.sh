#!/usr/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You must be root to run this script."
  exit 1
else
  echo "Currently running add-local-user script as root."
fi

read -p "Enter the username to create: " username

if [ -z "$username" ]; then
  echo "User $username already exists."
  exit 1
else
  sudo useradd $username
fi

read -p "Enter the name of the person or the application that will be using this account: " fullname
sudo usermod -c "$fullname" $username

echo "Enter the password to use for the account: "
sudo passwd $username

password=`sudo grep $username /etc/shadow | cut -d: -f2`
echo "The password for user $username is: $password"
echo "Password for user $username successfully changed."

sudo passwd --expire $username

echo -e "\nUsername: $username \nHostname: $HOSTNAME"