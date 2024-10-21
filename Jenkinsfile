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
