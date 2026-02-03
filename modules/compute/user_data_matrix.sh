#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install dependencies
apt-get install -y wget apt-transport-https software-properties-common postgresql-client

# Add Matrix Synapse repository
wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/matrix-org.list

# Install Matrix Synapse
apt-get update
apt-get install -y matrix-synapse-py3

# Configure Matrix to use PostgreSQL
cat > /etc/matrix-synapse/homeserver.yaml <<EOF
server_name: "victim-support.local"
pid_file: /var/run/matrix-synapse.pid

listeners:
  - port: 8008
    tls: false
    type: http
    x_forwarded: true
    resources:
      - names: [client, federation]
        compress: false

database:
  name: psycopg2
  args:
    user: dbadmin
    password: ${db_password}
    database: ${db_name}
    host: ${db_endpoint}
    cp_min: 5
    cp_max: 10

log_config: "/etc/matrix-synapse/log.yaml"
media_store_path: /var/lib/matrix-synapse/media
enable_registration: true
enable_registration_without_verification: false
EOF

# Restart Matrix Synapse
systemctl restart matrix-synapse
systemctl enable matrix-synapse

# Log completion
echo "Matrix Synapse installation completed" > /var/log/user-data.log