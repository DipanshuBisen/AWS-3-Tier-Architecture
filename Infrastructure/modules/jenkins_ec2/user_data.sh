#!/bin/bash

set -e

# Update packages
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
    fontconfig \
    openjdk-21-jre \
    curl \
    wget \
    unzip \
    git \
    awscli

# Verify Java
java -version

# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
    -o /usr/share/keyrings/jenkins-keyring.asc

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
apt-get update -y
apt-get install -y jenkins

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Wait for Jenkins to generate the initial password
echo "Waiting for Jenkins to start..."

for i in {1..30}; do
    if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
        break
    fi
    sleep 5
done

# Save initial Jenkins password
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    cp /var/lib/jenkins/secrets/initialAdminPassword /home/ubuntu/jenkins-initial-password
    chown ubuntu:ubuntu /home/ubuntu/jenkins-initial-password
    chmod 600 /home/ubuntu/jenkins-initial-password
fi

# Restart Jenkins
systemctl restart jenkins

echo "Jenkins installation completed."
systemctl status jenkins --no-pager