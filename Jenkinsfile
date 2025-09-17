pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "nodejs-app"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    // Declare dockerImage with def
                    def dockerImage = docker.build("${env.DOCKER_IMAGE}:${env.BUILD_ID}")
                    // Save to env for later stages
                    env.DOCKER_TAG = "${env.DOCKER_IMAGE}:${env.BUILD_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def dockerImage = docker.image(env.DOCKER_TAG)
                    dockerImage.inside {
                        // point cache to ./tmp or ./node_modules/.cache
                        sh 'npm config set cache /usr/src/app/.npm-cache --global'
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubeconfig(credentialsId: 'kubeconfig', serverUrl: 'https://127.0.0.1:32769') {
                        sh 'kubectl apply -f kubernetes-deployment.yml'
                    }
                }
            }
        }
    }
}
