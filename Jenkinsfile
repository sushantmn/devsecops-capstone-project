pipeline {
    agent any
    environment {
        // Replace with your actual Docker Hub username
        DOCKER_HUB_USER = 'your-dockerhub-id'
        IMAGE_NAME = 'capstone-app'
    }
    stages {
        stage('Checkout') {
            steps {
                // Pulls code from your GitHub repository
                checkout scm
            }
        }
        stage('Build & Security Scan') {
            steps {
                script {
                    // Build the Docker image locally on your Azure VM
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                    
                    // DevSecOps Gate: Only proceed if no CRITICAL vulnerabilities are found
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
