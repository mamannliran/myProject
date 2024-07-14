#! /bin/bash

sudo apt update -y

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


# Start Docker
sudo systemctl start docker

# Enable Docker to run on boot
sudo systemctl enable docker

# Create a shell script to run the server by taking the image tagged as simple-web-app:release from the ECR 
cat << EOT > start-website
/bin/sh -e -c 'echo $(aws ecr get-login-password --region us-east-1) | docker login -u AWS --password-stdin ${repository_url}'
sudo docker pull ${repository_url}:release
sudo docker run -p 80:8000 ${repository_url}:release
EOT

# Move the script into the specific ubuntu linux start up folder, in order for the script to run after boot
sudo mv start-website /var/lib/cloud/scripts/per-boot/start-website

# Mark the script as executable
sudo chmod +x /var/lib/cloud/scripts/per-boot/start-website

# Run the script
/var/lib/cloud/scripts/per-boot/start-website