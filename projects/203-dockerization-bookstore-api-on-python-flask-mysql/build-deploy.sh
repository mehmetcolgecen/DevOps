#! /bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir -p /home/ec2-user/bookstore-api
<<<<<<< HEAD
TOKEN="" #"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@"
FOLDER="https://${TOKEN}raw.githubusercontent.com/mehmetcolgecen/DevOps/main/projects/203-dockerization-bookstore-api-on-python-flask-mysql/"
=======
TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
FOLDER="https://$TOKEN@raw.githubusercontent.com/clarusway/cw-workshop/dev/devops/projects/202-dockerization-bookstore-api-on-python-flask-mysql/"
>>>>>>> 5a1c9f02536c3014ed2890184331e4ede12e11fb
curl -s --create-dirs -o "/home/ec2-user/bookstore-api/app.py" -L "$FOLDER"bookstore-api.py
curl -s --create-dirs -o "/home/ec2-user/bookstore-api/requirements.txt" -L "$FOLDER"requirements.txt
curl -s --create-dirs -o "/home/ec2-user/bookstore-api/Dockerfile" -L "$FOLDER"Dockerfile
curl -s --create-dirs -o "/home/ec2-user/bookstore-api/docker-compose.yml" -L "$FOLDER"docker-compose.yml
cd /home/ec2-user/bookstore-api
<<<<<<< HEAD
docker-compose up -d --build
=======
docker build -t callahanclarus/bookstore-api:latest .
docker-compose up -d
>>>>>>> 5a1c9f02536c3014ed2890184331e4ede12e11fb
