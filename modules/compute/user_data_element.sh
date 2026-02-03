#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install nginx and dependencies
apt-get install -y nginx wget unzip

# Download Element Web
ELEMENT_VERSION="v1.11.50"
cd /tmp
wget https://github.com/vector-im/element-web/releases/download/$ELEMENT_VERSION/element-$ELEMENT_VERSION.tar.gz
tar -xzf element-$ELEMENT_VERSION.tar.gz
mv element-$ELEMENT_VERSION /var/www/element

# Configure Element
cat > /var/www/element/config.json <<EOF
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "http://${matrix_server_ip}:8008",
            "server_name": "victim-support.local"
        }
    },
    "brand": "Victim Support Platform",
    "disable_guests": true,
    "disable_3pid_login": true,
    "default_country_code": "GB"
}
EOF

# Configure Nginx
cat > /etc/nginx/sites-available/element <<EOF
server {
    listen 80;
    server_name _;
    
    root /var/www/element;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

ln -sf /etc/nginx/sites-available/element /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Restart nginx
systemctl restart nginx
systemctl enable nginx

# Log completion
echo "Element Web installation completed" > /var/log/user-data.log