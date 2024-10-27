@Library('github.com/releaseworks/jenkinslib') _

node {
    stage("List S3 buckets") {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            sh 'aws s3 ls --region us-east-1'
        }
    }
}

pipeline {
    agent any
    environment {
        TERRAFORM_DIR = 'terraform/backend'
        TERRAFORM_VERSION = '1.9.8'
        INSTALL_DIR = "${WORKSPACE}/terraform"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh '''
                        export TF_VAR_access_key=$AWS_ACCESS_KEY_ID
                        export TF_VAR_secret_key=$AWS_SECRET_ACCESS_KEY
                        aws s3 ls
                        make init
                    '''
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'make plan'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
