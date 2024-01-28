#!/usr/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You must be root to run this script." >&2
  exit 1
else
  echo "Currently running add-local-user script as root." &> /dev/null
fi

if [[ "${#}" -lt 1 ]]
then
  echo "Usage:${0} username [FULL NAME]" >&2
  echo "Create an account by typing in a username and the full name. e.g johndoe John Doe" >&2
  exit 1
fi

username="${1}"

shift
fullname="${@}"

if [ -z "$username" ]; then
  echo "User $username already exists." >&2
  exit 1
else
  sudo useradd $username &> /dev/null
fi

if [[ "${?}" -ne 0 ]]
then
  echo "The user account was not created" >&2
  exit 1
fi

sudo usermod -c "$fullname" $username &> /dev/null

password=`openssl rand -base64 48 | cut -c1-8`

echo $password | passwd --stdin $username &> /dev/null

if [[ "${?}" -ne 0 ]]
then
  echo "Unable to set password for user $username" >&2
  exit 1
else
  echo "Password for user $username set successfully." &> /dev/null
fi

sudo passwd --expire $username &> /dev/null

echo -e "Username: \n$username \n\nPassword: \n$password \n\nHost: \n$HOSTNAME"