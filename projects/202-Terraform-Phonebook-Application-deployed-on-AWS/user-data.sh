#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y
<<<<<<< HEAD
TOKEN="xxxxxxxxxxxxx"
=======
TOKEN="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"
>>>>>>> 5a1c9f02536c3014ed2890184331e4ede12e11fb
cd /home/ec2-user && git clone https://$TOKEN@github.com/timothy-clark/phonebook.git
python3 /home/ec2-user/phonebook/phonebook-app.py