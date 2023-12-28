pipeline {
    agent any

    environment {
        registry = '510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices'
        dockerimage = ''
        /* RELEASE_NAMES = ["mongo", "postgres", "rabbitmq"]  */
    }

    stages {
        stage('Checkout'){
            steps {
                git branch: 'main', url: 'https://github.com/Yn-Olvr/microservices.git'
            }
        }
        stage('Build all services') {
            steps {
                sh 'docker build -t auth ./src/auth-service/'
                sh 'docker build -t converter-service ./src/converter-service/'
                sh 'docker build -t gateway-service ./src/gateway-service/'
                sh 'docker build -t notification-service ./src/notification-service/'
            }      
        }
        stage('Push Docker Images to ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 510314780674.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'docker tag auth 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:auth'
                    sh 'docker tag converter-service 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:converter'
                    sh 'docker tag notification-service 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:notification'
                    sh 'docker tag gateway-service 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:gateway'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:auth'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:converter'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:gateway'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:notification'

                }
            }
        }

        /* stage('Check existing helm releases'){
            steps {
                script{
                    def skipDeployment = false

                    // loop through each release name and check if it exists
                    RELEASE_NAMES.each { releaseName ->
                        echo "Checking if release '${releaseName}' exists..."
                        def helmListCommand = "helm list --filter '\\^${releaseName}$' --short"
                        def helmListOutput = sh(script: helmListCommand, returnStdout: true).trim()
                        if (helmListOutput == releaseName) {
                            echo "Release '${releaseName}' already exists. Marking to skip deployment."
                            skipDeployment = true
                        }
                    }

                    // If any release exists, skip further deployment
                    if (skipDeployment) {
                        currentBuild.result = 'SUCCESS'
                        error("One or more releases already exist. Skipping deployment.")
                    }
                }
            }
        } */
        stage('Install helm chart for MongoDB, Postgres & RabbitMQ') {
            /* when {
                // Only proceed if skipDeployment is false
                expression { currentBuild.result = 'SUCCESS'}
            } */
            steps {
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'eks_credentials', namespace: '', serverUrl: '') {
                        sh 'helm install mongo ./Helm_charts/MongoDB/'
                        sh 'helm install postgres ./Helm_charts/Postgres/'
                        sh 'helm install rabbitmq ./Helm_charts/RabbitMQ/'
                }
            }      
        }
        stage('Apply kubernetes manifest files for the services'){
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'eks_credentials', namespace: '', serverUrl: '') {
                 sh 'kubectl apply -f ./src/auth-service/manifest/'
                 sh 'kubectl apply -f ./src/gateway-service/manifest/'
                 sh 'kubectl apply -f ./src/converter-service/manifest/'
                 sh 'kubectl apply -f ./src/notification-service/manifest/'
                }
            }
        }
    }
}
