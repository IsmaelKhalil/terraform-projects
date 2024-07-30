#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo 'Welcome to the Apache Web Server, Terraform Edition!' | sudo tee -a /var/www/html/index.html