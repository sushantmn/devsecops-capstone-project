pipeline {
    agent any
    environment {
        // CHANGE THIS to your actual Docker Hub username
        DOCKER_HUB_USER = 'sushantnm' 
        IMAGE_NAME = 'capstone-app'
    }
    stages {
        // You can remove the manual 'Checkout' stage because Jenkins
        // already does this automatically at the start of the pipeline.
        
        stage('Build & Security Scan') {
            steps {
                script {
                    // This command is failing because the CLI is missing
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                    sh "trivy image --severity CRITICAL --exit-code 1 ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                // Securely use the token you saved as 'docker-hub-creds'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', 
                                 passwordVariable: 'DOCKER_HUB_PASSWORD', 
                                 usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                    sh "echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
}
