#!/bin/bash

# Download the Splunk Universal Forwarder package
wget -O splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz"

# Extract the package
tar -xzf splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz -C /opt

echo "###### Adding default Splunk Admin user and password ########"

cat > /opt/splunkforwarder/etc/system/local/user-seed.conf << 'EOF'
[user_info]
USERNAME = admin
PASSWORD = P@ssword123
EOF

# Install the Splunk Universal Forwarder
/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt


# Restart the Splunk Universal Forwarder
/opt/splunkforwarder/bin/splunk restart

/opt/splunkforwarder/bin/splunk status

