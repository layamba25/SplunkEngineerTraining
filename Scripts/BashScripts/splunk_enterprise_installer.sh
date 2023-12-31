#!/bin/bash

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "###### This script must be run as root #######"
    exit 1
fi
# Run yum or apt update and upgrade to ensure the system is up to date
echo "############ Updating and Upgrading the system #############"
# Run base on OS type (RHEL/CentOS or Debian/Ubuntu)
if [[ -f /etc/redhat-release ]]; then
    yum update -y
    yum upgrade -y
elif [[ -f /etc/debian_version ]]; then
    apt-get install -y debian-goodies
    apt-get update -y
    apt-get install -y debian-goodies
    apt-get upgrade -y
fi

# First configure the Linux host to meet the Splunk Enterprise system requirements
# https://docs.splunk.com/Documentation/Splunk/8.1.2/Installation/Systemrequirements#System_requirements_for_Linux

# Disable THP on boot
echo "############ Disabling THP on boot #############"
cat > /etc/systemd/system/disable-thp.service << 'EOF'
[Unit]
Description=Disable Transparent Huge Pages (THP)
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=splunk.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled && echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"

[Install]
WantedBy=basic.target
EOF

# Update Ulimits
echo "############ Updating Ulimits #############"
cat > /etc/security/limits.d/99-splunk.conf << 'EOF'
splunk_user soft nofile 64000
splunk_user hard nofile 64000
splunk_user soft nproc 20480
splunk_user hard nproc 20480
EOF

# Update Kernel Parameters
echo "############ Updating Kernel Parameters #############"
cat > /etc/sysctl.d/99-splunk.conf << 'EOF'
vm.max_map_count=262144
EOF

# Reload Systemd
echo "############## Reloading Systemd ###############"
systemctl daemon-reload

############################### Splunk Enterprise Installation ###############################
# 1. Create a splunk_user with sudo privileges and no password
echo "###### Creating splunk_user with sudo privileges and no password ########"
sudo useradd -m -s /bin/bash splunk_user
echo "splunk_user ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/splunk-sudoers

# 2. Install Splunk from the provided URL
wget -O /tmp/splunk.tgz https://download.splunk.com/products/splunk/releases/9.1.1/linux/splunk-9.1.1-64e843ea36b1-Linux-x86_64.tgz
# sleep 2m

# 3. Extract and install
tar -xzvf /tmp/splunk.tgz -C /opt/
# sleep 3m


# 4.0 Add Default Splunk Admin user and password
echo "###### Adding default Splunk Admin user and password ########"

cat > /opt/splunk/etc/system/local/user-seed.conf << 'EOF'
[user_info]
USERNAME = admin
PASSWORD = P@ssword123
EOF

# 4.1 Disable disk usage warning
cat > /opt/splunk/etc/system/local/server.conf << 'EOF'
[diskUsage]
minFreeSpace = 0
EOF

# 4.2 Change ownership
echo "############ Changing ownership of /opt/splunk to splunk_user #############"
sudo chown -R splunk_user:splunk_user /opt/splunk
# sleep 2m

# 5. Start Boot start
echo "############# Enabling Splunk to start at boot via Systemd ##############"
/opt/splunk/bin/splunk enable boot-start -systemd-managed 1 -user splunk_user --accept-license --answer-yes --no-prompt

# sleep 1m
# 6. Change ownership
sudo chown -R splunk_user:splunk_user /opt/splunk

# 7. Reload Systemd
echo "############## Reloading Systemd ###############"
systemctl daemon-reload
echo ".....Done Reloading Systemd....."

echo "############## Enabling Splunkd ##############"
systemctl enable Splunkd
echo ".....Done Enabling Splunkd....."

echo "############### Starting Splunkd ###############"
systemctl start Splunkd
echo ".....Done Starting Splunkd....."

# Check Splunkd status

echo "############### Checking Splunkd status ################"

if sudo systemctl status Splunkd | grep -q "active (running)"; then
    echo "Splunkd is running"
else
    echo "Splunkd is not running"
    exit 1
fi