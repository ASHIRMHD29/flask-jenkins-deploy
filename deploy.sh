#!/bin/bash

APP_DIR="/opt/python-app"

# Stop existing app
pkill -f "python3 app.py" || true

# Create app directory
mkdir -p $APP_DIR

# Extract tarball to app directory
tar -xzf /tmp/python-app.tar.gz -C $APP_DIR
cd $APP_DIR

# Install Python dependencies
pip3 install -r requirements.txt

# Start the app in background
nohup python3 app.py > app.log 2>&1 &

echo "✅ Flask app deployed and running on port 5000"
