@Library('github.com/releaseworks/jenkinslib') _

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

        stage('List S3 buckets') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'aws s3 ls --region us-east-1'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export TF_VAR_access_key=$AWS_ACCESS_KEY_ID
                        export TF_VAR_secret_key=$AWS_SECRET_ACCESS_KEY
                        export TF_VAR_environment=sandbox
                        make init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export TF_VAR_access_key=$AWS_ACCESS_KEY_ID
                        export TF_VAR_secret_key=$AWS_SECRET_ACCESS_KEY
                        export TF_VAR_environment=sandbox
                        make plan
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
