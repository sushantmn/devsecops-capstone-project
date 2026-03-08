pipeline {
    agent any
    environment {
        IMAGE_NAME = 'capstone-app'
    }
    stages {
        stage('Build & Security Scan') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds',
                                                     passwordVariable: 'PASS',
                                                     usernameVariable: 'USER')]) {

                        def fullImageName = "${USER}/${IMAGE_NAME}:${BUILD_NUMBER}"

                        sh "docker build -t ${fullImageName} ."

                        // Section D: Trivy Security Scan
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

                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${BUILD_NUMBER}"

                    sh "docker tag ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Absolute host path to the volume data
                    def HOST_VOLUME_PATH = "/var/lib/docker/volumes/jenkins_home/_data"
                    def HOST_WORKSPACE = "${HOST_VOLUME_PATH}/workspace/DevSecOps-Capstone-Pipeline"
                    def HOST_KUBECONFIG = "${HOST_VOLUME_PATH}/k3s-config"
                    
                    // We mount the config directly to /.kube/config which is the default for this image
                    // We also pass the --server flag to ensure it hits the host's K3s API [cite: 2026-03-08]
                    def kubectlCmd = "docker run --rm -v ${HOST_KUBECONFIG}:/.kube/config -v ${HOST_WORKSPACE}:/apps -w /apps bitnami/kubectl:latest --server=https://172.17.0.1:6443 --insecure-skip-tls-verify"
                    
                    sh "${kubectlCmd} apply -f k8s/deployment.yaml"
                    sh "${kubectlCmd} apply -f k8s/service.yaml"
                    
                    // Verifying the rollout status to ensure the pods are healthy [cite: 2026-03-08]
                    sh "${kubectlCmd} rollout status deployment/capstone-app"
                }
            }
        }

    }
    post {
        always {
            sh 'docker logout'
        }
    }
}