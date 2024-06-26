#!/bin/bash

# Make cool codemaxxers logo here


# Here, check to see if /deployments exists. If it doesn't exist, create it (this script will be run with sudo)
if [ ! -d "/deployments" ]; then
    mkdir /deployments
fi

# Here, check to see if the directory /deployments/codemaxxers exists. If not, create it
if [ ! -d "/deployments/codemaxxers" ]; then
    mkdir /deployments/codemaxxers
fi

# Here, check to see if the directory /deployments/codemaxxers/data exists. If not, create it
if [ ! -d "/deployments/codemaxxers/data" ]; then
    mkdir /deployments/codemaxxers/data
fi

# Here, change directory to /deployments/codemaxxers and git clone the following links:
cd /deployments/codemaxxers
git clone https://github.com/Codemaxxers/codemaxxerScripts.git
git clone https://github.com/Codemaxxers/codemaxxerConnections.git
git clone https://github.com/Codemaxxers/codemaxxerBackend.git

# Check to see if the directory /etc/nginx exists
if [ ! -d "/etc/nginx" ]; then
    echo "Nginx is not installed. Please install Nginx and run the script again."
    exit 1
fi

# Copy all files from /deployments/codemaxxers/codemaxxerScripts/data/sites-available/ to /etc/nginx/sites-available/
# and create symlinks for the copied files in /etc/nginx/sites-enabled/
for file in /deployments/codemaxxers/codemaxxerScripts/data/sites-available/*; do
    filename=$(basename "$file")
    cp "$file" /etc/nginx/sites-available/
    ln -s /etc/nginx/sites-available/"$filename" /etc/nginx/sites-enabled/"$filename"
done

# Permissions
chmod +x /deployments/codemaxxers/codemaxxerScripts/*

# Add your custom commands for the backend and connections repositories
cd /deployments/codemaxxers/codemaxxerBackend
docker-compose up -d --build

cd /deployments/codemaxxers/codemaxxerConnections
docker-compose up -d --build

# Check Nginx configuration and restart Nginx
nginx -t
systemctl restart nginx

# Run certbot for SSL certificates
certbot --nginx
echo "Done! CodeMaxxers has been deployed!"