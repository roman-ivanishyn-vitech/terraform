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
        stage('AWS & Terraform  ') {
                    steps {
                        sh 'terraform --version'
                        sh 'aws --version'
                    }
                }

    }

    post {
        always {
            cleanWs()
        }
    }
}
