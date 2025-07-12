#!/bin/bash

APP_DIR="/opt/python-app"
PY_ENV="$APP_DIR/venv"

# Ensure Python and venv are available
sudo apt-get update -y
sudo apt-get install -y python3 python3-venv python3-pip

# Create app directory
sudo mkdir -p $APP_DIR
sudo chown -R $USER:$USER $APP_DIR

# Extract code
tar -xzf /tmp/python-app.tar.gz -C $APP_DIR

# Create virtual environment
python3 -m venv $PY_ENV

# Activate virtual environment
source $PY_ENV/bin/activate

# Install dependencies
pip install -r $APP_DIR/requirements.txt

# Run the app in background
nohup python $APP_DIR/app.py > $APP_DIR/app.log 2>&1 &
echo "✅ Flask app deployed and running on port 5000"

