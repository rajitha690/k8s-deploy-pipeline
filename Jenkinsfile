pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/flask-app:latest'
        KUBECONFIG_CREDENTIAL_ID = 'kubeconfig-cred'  // Jenkins credential for KUBECONFIG
        DOCKER_CREDENTIAL_ID = 'dockerhub-cred'      // Jenkins credential for DockerHub login
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/dimpleswapna/k8s-deploy-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    script {
                        sh "docker build -t $DOCKER_IMAGE ."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIAL_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push $DOCKER_IMAGE"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIAL_ID}", variable: 'KUBECONFIG')]) {
                    script {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                        sh 'kubectl apply -f k8s/service.yaml'
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    def status = sh(script: "kubectl rollout status deployment/flask-app", returnStatus: true)
                    if (status != 0) {
                        echo "Deployment failed! Initiating rollback..."
                        sh "kubectl rollout undo deployment/flask-app"
                        error("Deployment verification failed. Rolled back.")
                    } else {
                        echo "Deployment successful!"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
        success {
            echo "Pipeline completed successfully."
        }
    }
}
