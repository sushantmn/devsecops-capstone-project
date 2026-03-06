pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'sushantnm' 
        IMAGE_NAME = 'capstone-app'
    }
    stages {
        
        stage('Build & Security Scan') {
            steps {
                script {
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
                    sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
	
	stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use the verified config file we just tested
                    withEnv(["KUBECONFIG=/var/jenkins_home/k3s-config"]) {
                        // Apply the manifests from your k8s directory
                        sh 'kubectl apply -f k8s/deployment.yaml --insecure-skip-tls-verify'
                        sh 'kubectl apply -f k8s/service.yaml --insecure-skip-tls-verify'
                        
                        // Force an update to use the latest image pushed in the previous stage
                        sh 'kubectl rollout restart deployment/capstone-app --insecure-skip-tls-verify'
                    }
                }
            }
        }
    }
}
