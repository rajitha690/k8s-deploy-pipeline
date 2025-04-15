pipeline {
    agent any

    environment {
        IMAGE_NAME = "rajitha390/k8s-deploy-pipeline"
        TAG = "v1"
        KUBECONFIG = "/var/lib/jenkins/kubeconfig"  // ✅ Updated path
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rajitha690/k8s-deploy-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $IMAGE_NAME:$TAG ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([ credentialsId: 'docker-credentials', url: '' ]) {
                    sh "docker push $IMAGE_NAME:$TAG"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withEnv(["KUBECONFIG=$KUBECONFIG"]) {
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withEnv(["KUBECONFIG=$KUBECONFIG"]) {
                    sh 'kubectl get pods'
                    sh 'kubectl get svc'
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
