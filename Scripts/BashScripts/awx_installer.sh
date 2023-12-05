#!/bin/bash

# Script to install AWX (Ansible AWX) on CentOS/RHEL and Debian/Ubuntu

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Function to install AWX on RHEL/CentOS
install_awx_rhel() {
    # Step 1: Install EPEL repository
    yum install -y epel-release

    # Step 2: Install Docker
    yum install -y docker
    systemctl start docker
    systemctl enable docker

    # Step 3: Install docker-compose
    yum install -y python3-pip
    pip3 install docker-compose
}

# Function to install AWX on Debian/Ubuntu
install_awx_debian() {
    # Step 1: Update package list and install prerequisites
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Step 2: Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

    # Step 3: Set up the Docker repository
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Step 4: Install Docker CE
    apt-get update
    apt-get install -y docker-ce

    # Step 5: Install docker-compose
    apt-get install -y python3-pip
    pip3 install docker-compose
}

# Install git and clone the AWX repository
install_common_packages() {
    # Install git
    if [ -x "$(command -v yum)" ]; then
        yum install -y git
    elif [ -x "$(command -v apt-get)" ]; then
        apt-get install -y git
    fi

    # Clone the AWX repository
    git clone https://github.com/ansible/awx.git
    cd awx/installer/

    # Install Ansible
    if [ -x "$(command -v yum)" ]; then
        yum install -y ansible
    elif [ -x "$(command -v apt-get)" ]; then
        apt-get install -y ansible
    fi
}

# Detect the OS type and run the appropriate installation
if [ -x "$(command -v yum)" ]; then
    echo "Detected RHEL/CentOS"
    install_awx_rhel
elif [ -x "$(command -v apt-get)" ]; then
    echo "Detected Debian/Ubuntu"
    install_awx_debian
else
    echo "Unsupported operating system"
    exit 1
fi

# Install common packages and run AWX installation
install_common_packages
ansible-playbook -i inventory install.yml

echo "AWX installation complete."
