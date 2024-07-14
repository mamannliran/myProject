#! /bin/bash
sudo apt update -y

sudo apt install fontconfig openjdk-17-jre -y

# Install Git
sudo apt install -y git

# Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y

sudo apt-get install jenkins -y

# Enable jenkins to run on boot
sudo systemctl enable jenkins

# Start Jenkins
sudo systemctl start jenkins


sudo systemctl daemon-reload


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

# Let Jenkins and the current user use docker
sudo usermod -a -G docker ubuntu
sudo usermod -a -G docker jenkins

# Create the opt folder in the jenkins home
sudo mkdir /var/lib/jenkins/opt
sudo chown jenkins:jenkins  /var/lib/jenkins/opt

# Download and install arachni as jenkins user
wget https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz 
tar -zxf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz 
rm arachni-1.5.1-0.5.12-linux-x86_64.tar.gz 
sudo chown -R jenkins:jenkins arachni-1.5.1-0.5.12/
sudo mv arachni-1.5.1-0.5.12 /var/lib/jenkins/opt

# Save the instance_id, repositories urls and bucket name to use in the pipeline
sudo /bin/bash -c "echo ${repository_url} > /var/lib/jenkins/opt/repository_url"
sudo /bin/bash -c "echo ${repository_test_url} > /var/lib/jenkins/opt/repository_test_url"
sudo /bin/bash -c "echo ${repository_staging_url} > /var/lib/jenkins/opt/repository_staging_url"
sudo /bin/bash -c "echo ${instance_id} > /var/lib/jenkins/opt/instance_id"
sudo /bin/bash -c "echo ${bucket_logs_name} > /var/lib/jenkins/opt/bucket_name"

# Change ownership and group of these files
sudo chown -R jenkins:jenkins /var/lib/jenkins/opt/

# Wait for Jenkins to boot up
sudo sleep 60


#####################################################
#######            SET UP JENKINS             #######
#####################################################

#---------------------------------------------#
#------> DEFINE THE GLOBAL VARIABLES <--------#
#---------------------------------------------#

export url="http://${public_dns}:8080"
export user="${admin_username}"
export password="${admin_password}"
export admin_fullname="${admin_fullname}"
export admin_email="${admin_email}"
export remote="${remote_repo}"
export jobName="${job_name}"
export jobID="${job_id}"

#---------------------------------------------#
#-----> COPY THE CONFIG FILES FROM S3 <-------#
#---------------------------------------------#

sudo aws s3 cp s3://${bucket_config_name}/ ./ --recursive
sudo chmod +x *.sh

#---------------------------------------------#
#----------> RUN THE CONFIG FILES  <----------#
#---------------------------------------------#

./create_admin_user.sh
./download_install_plugins.sh
sudo sleep 120
./confirm_url.sh
./create_credentials.sh

# Output the credentials id in a credentials_id file
python3 -c "import sys;import json;print(json.loads(raw_input())['credentials'][0]['id'])" <<< $(./get_credentials_id.sh) > credentials_id

./create_multibranch_pipeline.sh

#---------------------------------------------#
#---------> DELETE THE CONFIG FILES <---------#
#---------------------------------------------#

sudo rm *.sh credentials_id

reboot