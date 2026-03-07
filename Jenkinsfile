pipeline {
    agent any
    environment {
        // We pull these from the 'docker-hub-creds' defined in Jenkins
        IMAGE_NAME = 'capstone-app'
    }
    stages {
        stage('Build & Security Scan') {
            steps {
                script {
                    // Pulling the username from credentials so it's not hardcoded in the script
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', 
                                     passwordVariable: 'PASS', 
                                     usernameVariable: 'USER')]) {
                        
                        def fullImageName = "${USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                        
                        sh "docker build -t ${fullImageName} ."
                        
                        // Section D: Trivy Security Scan 
                        // Updated to run as a container since the binary is not in the Jenkins image
                        sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --severity CRITICAL --exit-code 1 ${fullImageName}"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', 
                                 passwordVariable: 'DOCKER_HUB_PASSWORD', 
                                 usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                    
                    sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
                    
                    // Pushing the specific Build Version
                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    
                    // Pushing the 'latest' tag for production
                    sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                }
            }
        }
	
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Section G: Kubernetes Deployment
                    withEnv(["KUBECONFIG=/var/jenkins_home/k3s-config"]) {
                        sh 'kubectl apply -f k8s/deployment.yaml --insecure-skip-tls-verify'
                        sh 'kubectl apply -f k8s/service.yaml --insecure-skip-tls-verify'
                        
                        // Forces K8s to pull the fresh 'latest' image we just pushed
                        sh "kubectl rollout restart deployment/${IMAGE_NAME} --insecure-skip-tls-verify"
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up the local images to save space on your Azure VM
            sh 'docker logout'
        }
    }
}