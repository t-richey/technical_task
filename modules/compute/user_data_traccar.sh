#!/bin/bash
set -e

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting Traccar installation..."

# Update system
apt-get update
apt-get upgrade -y

# Install Java (Traccar requires Java)
apt-get install -y default-jre default-jdk wget unzip postgresql-client

# Download and install Traccar
cd /tmp
wget https://github.com/traccar/traccar/releases/download/v5.12/traccar-linux-64-5.12.zip
unzip traccar-linux-64-5.12.zip
bash traccar.run

# Wait for Traccar to create default config
sleep 5

# Configure Traccar to use PostgreSQL instead of H2 (default embedded DB)
cat > /opt/traccar/conf/traccar.xml <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE properties SYSTEM 'http://java.sun.com/dtd/properties.dtd'>
<properties>
    <!-- Database Configuration -->
    <entry key='database.driver'>org.postgresql.Driver</entry>
    <entry key='database.url'>jdbc:postgresql://${db_endpoint}/${db_name}</entry>
    <entry key='database.user'>dbadmin</entry>
    <entry key='database.password'>${db_password}</entry>

    <!-- Server Configuration -->
    <entry key='web.port'>8082</entry>
    <entry key='web.path'>./web</entry>

    <!-- Tracking Port (default GPS protocol) -->
    <entry key='gps103.port'>5001</entry>
    
    <!-- Media storage -->
    <entry key='media.path'>./media</entry>
    
    <!-- Geocoding -->
    <entry key='geocoder.enable'>true</entry>
    <entry key='geocoder.type'>nominatim</entry>
    
    <!-- Notifications -->
    <entry key='notificator.types'>web,mail</entry>
</properties>
EOF

# Download PostgreSQL JDBC driver
wget https://jdbc.postgresql.org/download/postgresql-42.7.1.jar -O /opt/traccar/lib/postgresql-42.7.1.jar

# Set correct permissions
chown -R traccar:traccar /opt/traccar

# Restart Traccar service
systemctl restart traccar
systemctl enable traccar

# Create database tables
sleep 10
echo "Traccar installation completed. Accessible on port 8082."