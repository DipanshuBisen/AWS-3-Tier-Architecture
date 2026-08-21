#!/bin/bash

set -e

echo "===================================="
echo "Installing Java"
echo "===================================="

sudo apt-get update

sudo apt-get install -y openjdk-21-jdk curl

echo "Java version:"
java -version


echo "===================================="
echo "Creating application directory"
echo "===================================="

sudo mkdir -p /opt/java-login-app


echo "===================================="
echo "Downloading JAR from JFrog"
echo "===================================="

sudo curl -fL \
    -u "${JFROG_USERNAME}:${JFROG_PASSWORD}" \
    "${JAR_URL}" \
    -o /opt/java-login-app/java-login-app.jar


echo "===================================="
echo "Creating systemd service"
echo "===================================="

sudo tee /etc/systemd/system/java-login-app.service > /dev/null <<EOF

[Unit]
Description=Java Login Application
After=network.target

[Service]
User=root
WorkingDirectory=/opt/java-login-app
ExecStart=/usr/bin/java -jar /opt/java-login-app/java-login-app.jar

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

EOF


echo "===================================="
echo "Enabling application service"
echo "===================================="

sudo systemctl daemon-reload

sudo systemctl enable java-login-app

echo "Application installation completed."