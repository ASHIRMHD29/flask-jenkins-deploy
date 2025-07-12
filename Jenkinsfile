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
                tar -czf python-app.tar.gz app.py requirements.txt deploy.sh
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
                    sh '''#!/bin/bash
                    SSH_OPTIONS="-o StrictHostKeyChecking=no"

                    chmod 400 "$EC2_KEY"
                    scp $SSH_OPTIONS -i "$EC2_KEY" python-app.tar.gz "$EC2_USER@$EC2_IP:/tmp/"
                    scp $SSH_OPTIONS -i "$EC2_KEY" deploy.sh "$EC2_USER@$EC2_IP:/tmp/"
                    ssh $SSH_OPTIONS -i "$EC2_KEY" "$EC2_USER@$EC2_IP" 'chmod +x /tmp/deploy.sh && bash /tmp/deploy.sh'
                    '''
                }
            }
        }
    }
}
