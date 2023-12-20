#!/bin/bash

# Check the OS type
if [[ -f /etc/redhat-release ]]; then
    # RHEL or CentOS
    sudo yum install -y epel-release
    sudo yum install -y ansible
elif [[ -f /etc/debian_version ]]; then
    # Debian or Ubuntu
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
else
    echo "Unsupported OS type"
    exit 1
fi

# Create ansible user if it doesn't exist
if ! id -u ansible >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash ansible
fi

# Set Python 3 as the default Python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Generate SSH key for ansible user
if [[ ! -f /home/ansible/.ssh/id_rsa ]]; then
    sudo -u ansible ssh-keygen -t rsa -N "" -f /home/ansible/.ssh/id_rsa
fi

echo "Ansible installation and SSH key creation completed."
