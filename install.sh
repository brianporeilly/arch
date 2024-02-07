#!/bin/bash

set -e

VAR_FILE=ansible-osx/host_vars/localhost

# check if template vars need to be filled out
for VAR in "{HOSTNAME}" "{USER_FULLNAME}" "{USER_EMAIL}"
do
  var_check=$(grep $VAR $VAR_FILE) 2>&1 > /dev/null && returncode=$? || returncode=$?
  if [[ $returncode -eq 0 ]]; then
    echo "Please enter the desired value for $VAR..."
    read VALUE
    sed -i '' -e "s/$VAR/$VALUE/g" $VAR_FILE
  fi
done

# install ansible
echo "checking ansible..."
ansible_bin=$(which ansible) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    echo "ansible not installed, stopping..."
    exit 1
fi

cd ansible-osx
ansible-galaxy install -r requirements.yml
ansible-playbook playbook.yml --extra-vars="ansible_become_pass=$PASSWORD"
