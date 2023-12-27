#!/bin/bash

# Script to install AWX (Ansible AWX) on CentOS/RHEL and Debian/Ubuntu

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "============This script must be run as root===========" 1>&2
   exit 1
fi

useradd -m -s /bin/bash ansible
echo 'ansible ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers.d/ansible-sudoers

# Function to install AWX on RHEL/CentOS
install_awx_rhel() {
    # Step 1: Install EPEL repository
    echo "============installing prerequisites==========="
    yum update -y
    yum upgrade -y
    yum install -y epel-release
    yum install -y git gcc gcc-c++ nodejs gettext device-mapper-persistent-data lvm2 bzip2 python3-pip python3-devel python3-libselinux python3-docker-py python3-docker-compose python3-
    yum install -y ansible
 
    # Step 2: Install Docker
    echo "============installing docker==========="
    yum install -y docker
    systemctl start docker
    systemctl enable docker

    # Step 3: Install docker-compose
    echo "============installing docker-compose==========="
    yum install -y python3-pip
    pip3 install docker-compose

    # Step 4: Install Minikube
    echo "============installing minikube==========="
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    minikube start --cpus=2 --memory=2g --addons=ingress --driver=docker --force
    alias kubectl="minikube kubectl --"
    kubectl apply -k .

     # Step 5: Check Pods
    echo "============checking pods==========="
    kubectl get pods -n awx
    # kubectl config set-context --current --namespace=awx

    # Step 6: Get an save the admin password
    echo "============getting admin password==========="
    kubectl get secret awx-operator-admin-password -o jsonpath="{.data.password}" | base64 --decode > /var/log/admin_password.txt

    # Step 7: Configure Ingress Controller for Minikube
    echo "============configuring ingress controller==========="
    minikube addons enable ingress
    # kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/cloud/deploy.yaml
}

# Function to install AWX on Debian/Ubuntu
install_awx_debian() {
    # Step 1: Update package list and install prerequisites
    echo "============installing prerequisites==========="
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y debian-goodies
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Step 2: Add Docker’s official GPG key
    echo "============adding docker gpg key==========="
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

    # Step 3: Set up the Docker repository
    echo "============setting up docker repository==========="
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

    # Step 4: Install Docker CE
    echo "============installing docker ce==========="
    apt-get install -y docker-ce
    apt-get  install docker.io -y

    # Step 5: Install docker-compose
    echo "============installing docker-compose==========="
    apt-get install -y python3-pip
    pip3 install docker-compose

    # Step 6: Install Ranger and Kustomize
    echo "============installing Ranger==========="
    curl -sfL https://get.k3s.io | sh -
    kubectl version

    # Install Kustomize
    echo "============installing Kustomize==========="
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
    mv kustomize /usr/local/bin/

    # Run Kustomize file
    echo "============running kustomize file==========="
    kustomize build . | kubectl apply -f -
    kubectl get pods -n awx-operator
    sleep 20
    kustomize build . | kubectl apply -f -
    sleep 20
    kubectl get pods -n awx-operator



    # # Step 7: Check Pods
    # echo "============checking pods==========="
    # kubectl get pods -n awx-operator
    # kubectl config set-context --current --namespace=awx-operator

      # Step 6: Get an save the admin password
    echo "============getting admin password==========="
    kubectl get secret awx-operator-admin-password -o jsonpath="{.data.password}" --namespace awx-operator | base64 --decode > /var/log/admin_password.txt
}
   

# Install git and clone the AWX repository
install_common_packages() {
    # Install git
    if [ -x "$(command -v yum)" ]; then
        echo "============installing git ==========="
        yum install -y git unzip
    elif [ -x "$(command -v apt-get)" ]; then
        echo "============installing git ==========="
        apt-get install -y git unzip
    fi


    # Install Ansible
    if [ -x "$(command -v yum)" ]; then
        echo "============installing ansible ==========="
        yum install -y ansible
        yum install pwgen -y
        yum install -y make
    elif [ -x "$(command -v apt-get)" ]; then
        echo "============installing ansible ==========="
        apt-get install -y ansible
        apt install pwgen -y
        apt install -y make
    fi

   
   
}

# Detect the OS type and run the appropriate installation
if [ -x "$(command -v yum)" ]; then
    echo "============Detected RHEL/CentOS ==========="
    install_awx_rhel
    install_common_packages
elif [ -x "$(command -v apt-get)" ]; then
    echo "============Detected Debian/Ubuntu ==========="
    install_awx_debian
    install_common_packages
else
    echo "============Unsupported operating system ==========="
    exit 1
fi


sudo chown -R ansible:ansible /etc/rancher
sudo chown -R ansible:ansible /var/lib/rancher

echo "============AWX installation complete. ==========="
