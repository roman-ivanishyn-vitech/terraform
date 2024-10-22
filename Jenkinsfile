@Library('github.com/releaseworks/jenkinslib') _

pipeline {
    agent any
    environment {
        TERRAFORM_DIR = 'terraform/backend'
        TERRAFORM_VERSION = '1.9.8'
        INSTALL_DIR = "${WORKSPACE}/terraform"
        ACCESS_KEY = "AKIAQOZL5THGZ6GXDR6U"
        SECRET_KEY = "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"
     }

    stages {
        stage('Checkout ') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                AWS("--region=us-east-1 s3 ls")
            }
            steps {
                sh 'aws s3 ls'
                sh 'export TF_VAR_access_key=$ACCESS_KEY'
                sh 'export TF_VAR_secret_key=$SECRET_KEY'
                sh 'make init'
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
