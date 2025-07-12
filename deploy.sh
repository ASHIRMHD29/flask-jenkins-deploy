#!/bin/bash

APP_DIR="/opt/python-app"

# Create directory with sudo
sudo mkdir -p $APP_DIR

# Extract code
sudo tar -xzf /tmp/python-app.tar.gz -C $APP_DIR

# Change ownership so ubuntu user can access
sudo chown -R $USER:$USER $APP_DIR

# Go to app directory
cd $APP_DIR

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y python3-pip
pip3 install -r requirements.txt

# Run app
nohup python3 app.py > app.log 2>&1 &
echo "✅ Flask app deployed and running on port 5000"
