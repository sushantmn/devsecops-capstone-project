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
                    withEnv(["KUBECONFIG_PATH=/var/jenkins_home/k3s-config"]) {
                        // Using ${WORKSPACE} ensures the mount points to the exact checkout folder
                        def kubectlCmd = "docker run --rm -v ${KUBECONFIG_PATH}:/root/.kube/config -v ${WORKSPACE}:/apps -w /apps bitnami/kubectl:latest"
                        
                        sh "${kubectlCmd} apply -f k8s/deployment.yaml --insecure-skip-tls-verify"
                        sh "${kubectlCmd} apply -f k8s/service.yaml --insecure-skip-tls-verify"
                        sh "${kubectlCmd} rollout restart deployment/${IMAGE_NAME} --insecure-skip-tls-verify"
                    }
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