#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
TOKEN="xxxxxxxxxxxxx"
=======
TOKEN="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"
>>>>>>> 5a1c9f02536c3014ed2890184331e4ede12e11fb
=======
TOKEN="xxxxxxxxxxxxx"
>>>>>>> 52c97c4e33de0c84d6322f78c932ceafcd7b54a5
=======
TOKEN="xxxxxxxxxxxxx"
>>>>>>> 52c97c4e33de0c84d6322f78c932ceafcd7b54a5
=======
TOKEN="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"
>>>>>>> e4d47162a527adb7bbb6d4e17844506122c3a21d
cd /home/ec2-user && git clone https://$TOKEN@github.com/timothy-clark/phonebook.git
python3 /home/ec2-user/phonebook/phonebook-app.py