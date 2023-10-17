#!/bin/bash

# --------------------------------------------------------
# Set the root password. It includes, lowercase letters, uppercase letters, numbers and special characters for strength. 
# --------------------------------------------------------
# MYSQL_ROOT_PASSWORD="rootDBPass#12"


echo "Provisioning master..."

# --------------------------------------------------------
# Install software, configure settings, etc.
# Update the package manager
# --------------------------------------------------------
sudo apt update


# --------------------------------------------------------
# Upgrade applications
# --------------------------------------------------------
sudo apt upgrade -y
echo "Update and upgrade done"


# --------------------------------------------------------
# Install Ifconfig
# --------------------------------------------------------
sudo apt install net-tools


# --------------------------------------------------------
# Install the SSH server
# --------------------------------------------------------
sudo apt-get install -y openssh-server


# --------------------------------------------------------
# Define the username and password for the new user
# --------------------------------------------------------
new_username="altschool"
new_password="altschool1234"


# --------------------------------------------------------
# Create the user with a home directory and set the password
useradd -m -s /bin/bash "$new_username" && \
echo "$new_username:$new_password" | chpasswd && \
mkdir -p /home/vagrant/.ssh && \
chmod 700 /home/vagrant/.ssh && \
chown -R vagrant:vagrant /home/vagrant/.ssh

# --------------------------------------------------------
# Add the user to the sudo group (for systems using sudo)
# --------------------------------------------------------
usermod -aG sudo "$new_username"
echo "User '$new_username' has been created and granted root privileges."


# --------------------------------------------------------
# Enable SSH key-based authentication between the master and slave nodes
# --------------------------------------------------------
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.56.6


# --------------------------------------------------------
# Restart the SSH service to apply the changes
# --------------------------------------------------------
sudo systemctl restart sshd


# --------------------------------------------------------
# Copy the contents of /mnt/altschool on the master node to /mnt/altschool/slave on the slave node
# --------------------------------------------------------
ssh altschool@192.168.56.5 "rsync -av /mnt/altschool /home/altschool/"


# --------------------------------------------------------
# Install Apache web server and make it start on boot
# --------------------------------------------------------
sudo apt install -y apache2
sudo apachectl -k start 


# --------------------------------------------------------
# Install MySQL server and set root password
# --------------------------------------------------------
sudo apt install -y mysql-server


# --------------------------------------------------------
# Initialize MySQL with a default user and password on both nodes
# --------------------------------------------------------
# ssh altschool@192.168.56.3 "mysql -u root -p < /vagrant/init.sql"
# ssh altschool@192.168.56.5 "mysql -u root -p < /vagrant/init.sql"


# --------------------------------------------------------
# Update the MySQL configuration file
# --------------------------------------------------------
# sudo sed -i 's/validate_password_policy=0/validate_password_policy=1/g' /etc/mysql/my.cnf
# sudo sed -i 's/bind-address=127.0.0.1/bind-address=0.0.0.0/g' /etc/mysql/my.cnf
# sudo sed -i 's/skip-networking/\#skip-networking/g' /etc/mysql/my.cnf


# --------------------------------------------------------
# Start the MySQL Server and grep temporary password
# --------------------------------------------------------
echo "Starting MySQL server for the first time"

sudo systemctl start mysql 2> /dev/null

# tempRootPass="`sudo grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -m 1 | sed 's/.*root@localhost: //'`"


# --------------------------------------------------------
# Set new password for root user
# --------------------------------------------------------
# echo "Setting up new mysql server root password"
# sudo mysql -u "root" --password="$tempRootPass" --connect-expired-password -e "alter user root@localhost identified by '${MYSQL_ROOT_PASSWORD}'; flush privileges;"


# --------------------------------------------------------
# Do the basic hardening
# --------------------------------------------------------
# sudo mysql -u root --password="$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User=''; DROP DATABASE IF EXISTS test; DELETE FROM mysql.db WHERE Db='test OR Db='test\\_%'; FLUSH PRIVILEGES;"
# sudo systemctl status mysql

# --------------------------------------------------------
# Run the MySQL security script
# --------------------------------------------------------
sudo su
mysql_secure_installation < response.txt


# --------------------------------------------------------
# Confirm Installation Status
# --------------------------------------------------------
echo "MySQL installation and security configuration completed."


# --------------------------------------------------------
# Install PHP and required modules
# --------------------------------------------------------
sudo apt install -y php libapache2-mod-php php-mysql


# --------------------------------------------------------
# Enable Apache modules
# --------------------------------------------------------
a2enmod php7.4
sudo systemctl resload apache2


# --------------------------------------------------------
# Create a PHP test file to verify the installation
# --------------------------------------------------------
sudo echo "<?php

// Show all information, defaults to INFO_ALL
phpinfo();

// Show just the module information.
// phpinfo(8) yields identical results.
phpinfo(INFO_MODULES);

?>" > /var/www/html/index.php


# --------------------------------------------------------
# Reload Apache to apply changes
# --------------------------------------------------------
sudo systemctl reload apache2


# --------------------------------------------------------
# Display a message indicating the LAMP stack is installed
# --------------------------------------------------------
echo "LAMP stack (Apache, MySQL, PHP) has been successfully installed."


# --------------------------------------------------------
# Clean up and exit
# --------------------------------------------------------
exit 0
