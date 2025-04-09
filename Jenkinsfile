pipeline {
    agent any

    environment {
        IMAGE_NAME = "swpanahd/k8s-deploy-pipeline"
        TAG = "v1"
        KUBECONFIG = "/home/ubuntu/kubeconfig"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dimpleswapna/k8s-deploy-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Make sure Dockerfile is inside app/ directory
                    sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-creds') {
                        sh 'docker push ${IMAGE_NAME}:${TAG}'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${KUBECONFIG}"]) {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                        sh 'kubectl apply -f k8s/service.yaml'
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${KUBECONFIG}"]) {
                        sh 'kubectl get pods'
                        sh 'kubectl get svc'
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
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
