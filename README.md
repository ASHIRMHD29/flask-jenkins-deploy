
# Flask App CI/CD with Jenkins and EC2 Deployment

This project demonstrates a complete CI/CD pipeline using **Jenkins** to deploy a simple **Flask Python app** to a target **Ubuntu EC2 instance**. It also optionally includes GitHub webhook integration to trigger the pipeline on each code push.


---

## 🔧 Technologies Used

- Python 3 & Flask
- Jenkins (Pipeline as Code)
- Bash scripting
- AWS EC2 (Ubuntu)
- SSH & SCP
- GitHub Webhooks (optional)
- Virtualenv for Python environment
- `tar.gz` packaging for app delivery

---

## 📁 Project Structure

```
flask-jenkins-deploy/
├── app.py              # Python Flask app
├── requirements.txt    # Python dependencies
├── deploy.sh           # Deployment script run on EC2
├── Jenkinsfile         # Jenkins pipeline definition
└── README.md           # This file
```

---

## 🌐 What This Project Does

- ✅ Packages the app and dependencies into a `.tar.gz`
- ✅ Copies files to remote EC2 via `scp`
- ✅ Connects to EC2 via SSH and runs the deployment script
- ✅ Sets up a virtual environment
- ✅ Installs required packages using `pip`
- ✅ Runs Flask app in the background (`nohup`)
- ✅ Optionally auto-triggers Jenkins pipeline via GitHub webhook

---

## 🚀 Flask App Output

Once deployed, visiting `http://<EC2-PUBLIC-IP>:5000/` will show:

```
Hello, Ashir! This is a Flask app deployed via Jenkins on EC2.
```

---

## ✅ Prerequisites

- Jenkins installed and running (can be on same EC2 or separate)
- A target EC2 Ubuntu instance with:
  - Python 3, `python3-venv`, `python3-pip`
  - Port 5000 open in security group
- SSH access using `.pem` key
- Jenkins credentials setup:
  - `EC2_PRIVATE_KEY` (SSH key)
  - `EC2_USER` (`ubuntu`)
  - `EC2_IP` (target EC2 public IP)

---

## 🔐 Jenkins Credentials

| ID               | Type                      | Value                      |
|------------------|---------------------------|----------------------------|
| `EC2_PRIVATE_KEY`| SSH Username with Key     | Paste PEM content          |
| `EC2_USER`       | Secret Text               | `ubuntu`                   |
| `EC2_IP`         | Secret Text               | `<your-target-ec2-ip>`     |

---

## 🔁 Optional: Enable GitHub Webhook

To auto-trigger the pipeline on every Git push:

1. Go to your GitHub repo → Settings → Webhooks
2. Add a new webhook:
   - URL: `http://<your-jenkins-host>:8080/github-webhook/`
   - Content type: `application/json`
   - Events: Just the push event
3. In Jenkins job → General → Check **"GitHub project"** and add your repo URL
4. Under **Build Triggers**, check **"GitHub hook trigger for GITScm polling"**

---

## 📜 Sample Jenkinsfile

```groovy
pipeline {
    agent any

    environment {
        TAR_FILE = "python-app.tar.gz"
    }

    stages {
        stage('Package App') {
            steps {
                sh '''
                chmod +x deploy.sh
                tar -czf $TAR_FILE app.py requirements.txt deploy.sh
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([
                    string(credentialsId: 'EC2_USER', variable: 'EC2_USER'),
                    string(credentialsId: 'EC2_IP', variable: 'EC2_IP'),
                    sshUserPrivateKey(credentialsId: 'EC2_PRIVATE_KEY', keyFileVariable: 'EC2_KEY')
                ]) {
                    sh '''
                    export SSH_OPTIONS="-o StrictHostKeyChecking=no"
                    scp -i $EC2_KEY $TAR_FILE $EC2_USER@$EC2_IP:/tmp/
                    scp -i $EC2_KEY deploy.sh $EC2_USER@$EC2_IP:/tmp/
                    ssh -i $EC2_KEY $EC2_USER@$EC2_IP 'bash /tmp/deploy.sh'
                    '''
                }
            }
        }
    }
}
```

---

## 📂 deploy.sh (Server-side script)

```bash
#!/bin/bash

APP_DIR="/opt/python-app"
PY_ENV="$APP_DIR/venv"

sudo apt-get update -y
sudo apt-get install -y python3 python3-venv python3-pip

sudo mkdir -p $APP_DIR
sudo chown -R $USER:$USER $APP_DIR

tar -xzf /tmp/python-app.tar.gz -C $APP_DIR

python3 -m venv $PY_ENV
source $PY_ENV/bin/activate

pip install -r $APP_DIR/requirements.txt

nohup python $APP_DIR/app.py > $APP_DIR/app.log 2>&1 &
echo "✅ Flask app deployed and running on port 5000"
```

---

## 🧪 Test Access

After a successful Jenkins build, open your browser and visit:

```
http://<EC2_PUBLIC_IP>:5000/
```

---

## 👨‍💻 Author

**Ashir PKP**  
DevOps Engineer | Linux & Cloud Specialist  
GitHub: [@ASHIRMHD29](https://github.com/ASHIRMHD29)

---
