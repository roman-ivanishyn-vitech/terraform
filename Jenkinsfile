pipeline {
    agent any
    environment {
        TERRAFORM_DIR = 'terraform/backend'
        TERRAFORM_VERSION = '1.9.8'
        INSTALL_DIR = "${WORKSPACE}/terraform"
    }

    stages {
        stage('Checkout ') {
            steps {
                checkout scm
            }
        }
        stage('Install Make') {
                    steps {
                        // Install make if it's not already installed
                        sh '''
                        if ! command -v make &> /dev/null; then
                            apt-get update && apt-get install -y build-essential
                        fi
                        '''
                    }
                }
        stage('Terraform Init') {
            steps {
                sh 'make init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'make plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'make apply'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
