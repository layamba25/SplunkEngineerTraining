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
    pip3 install awxkit

    # Step 4: Selinux configuration
    sudo setenforce 0
}

# Function to install AWX on Debian/Ubuntu
install_awx_debian() {
    # Step 1: Update package list and install prerequisites
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Step 2: Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

    # Step 3: Set up the Docker repository
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

    # Step 4: Install Docker CE
    apt-get update
    apt-get install -y docker-ce

    # Step 5: Install docker-compose
    apt-get install -y python3-pip
    pip3 install docker-compose
    pip3 install awxkit

    # Step 6: Selinux configuration
    sudo setenforce 0
}

# Install git and clone the AWX repository
install_common_packages() {
    # Install git
    if [ -x "$(command -v yum)" ]; then
        yum install -y git unzip
    elif [ -x "$(command -v apt-get)" ]; then
        apt-get install -y git unzip
    fi


    # Install Ansible
    if [ -x "$(command -v yum)" ]; then
        yum install -y ansible
    elif [ -x "$(command -v apt-get)" ]; then
        apt-get install -y ansible
    fi

    # Clone the AWX repository
    # git clone https://github.com/ansible/awx.git
    # cd awx/installer/
    #Reference https://cloudinfrastructureservices.co.uk/how-to-install-ansible-awx-using-docker-compose-awx-container-20-04/
    cd /opt
    wget https://github.com/ansible/awx/archive/17.1.0.zip
    unzip 17.1.0.zip
    cd awx-17.1.0/installer/
    
    cp inventory inventory.bak

    secret_key=$(pwgen -N 1 -s 40)
    sed -i "s/^secret_key=.*$/secret_key=$secret_key/" inventory
    
    sed -i "s/^#admin_password=password*$/admin_password=password/" inventory
    # Generate a random password for the AWX admin user
    # admin_password=$(pwgen -N 1 -s 40)
    # sed -i "s/^admin_password=.*$/admin_password=$admin_password/" inventory

    # # Generate a random password for the AWX database
    # db_password=$(pwgen -N 1 -s 40)
    # sed -i "s/^pg_password=.*$/pg_password=$db_password/" inventory

    # # Generate a random password for the RabbitMQ messaging service
    # rabbitmq_password=$(pwgen -N 1 -s 40)
    # sed -i "s/^rabbitmq_password=.*$/rabbitmq_password=$rabbitmq_password/" inventory

    # # Generate a random password for the AWX memcached service
    # memcached_password=$(pwgen -N 1 -s 40)
    # sed -i "s/^memcached_password=.*$/memcached_password=$memcached_password/" inventory



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
ansible-playbook -i inventory install.yml

echo "AWX installation complete."
