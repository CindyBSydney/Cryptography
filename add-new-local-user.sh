#!/usr/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You must be root to run this script."
  exit 1
else
  echo "Currently running add-local-user script as root."
fi

if [[ "${#}" -lt 1 ]]
then
  echo "Usage:${0} username [FULL NAME]"
  echo "Create an account by typing in a username and the full name. e.g johndoe John Doe"
  exit 1
fi

username="${1}"

shift
fullname="${@}"

if [ -z "$username" ]; then
  echo "User $username already exists."
  exit 1
else
  sudo useradd $username
fi

if [[ "${?}" -ne 0 ]]
then
  echo "The user account was not created"
  exit 1
fi

sudo usermod -c "$fullname" $username

password=`openssl rand -base64 48 | cut -c1-8`

echo $password | passwd --stdin $username

if [[ "${?}" -ne 0 ]]
then
  echo "Unable to set password for user $username"
  exit 1
else
  echo "Password for user $username set successfully."
fi

sudo passwd --expire $username

echo -e "\nUsername: \n$username \n\nPassword: \n$password \n\nHost: \n$HOSTNAME"