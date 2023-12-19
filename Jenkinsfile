pipeline {
    agent any

    environment {
        registry = '510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices'
        dockerimage = '' 
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
<<<<<<< HEAD
                    sh docker.tag('auth', '510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:auth' + env.BUILD_NUMBER)
                    sh docker.tag('converter-service', '510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:converter' + env.BUILD_NUMBER)
                    sh docker.tag('notification-service', '510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:notification' + env.BUILD_NUMBER)
                    sh docker.tag('gateway-service', '510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:gateway' + env.BUILD_NUMBER)
                    sh docker.push('510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:auth' + env.BUILD_NUMBER)
                    sh docker.push('510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:converter' + env.BUILD_NUMBER)
                    sh docker.push('510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:gateway' + env.BUILD_NUMBER)
                    sh docker.push('510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:notification' + env.BUILD_NUMBER)
=======
                    sh 'docker tag auth 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:auth + $BUILD_NUMBER'
                    sh 'docker tag converter-service 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:converter + $BUILD_NUMBER'
                    sh 'docker tag notification-service 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:notification + $BUILD_NUMBER'
                    sh 'docker tag gateway-service 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:gateway + $BUILD_NUMBER'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:auth + $BUILD_NUMBER'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:converter + $BUILD_NUMBER'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:gateway + $BUILD_NUMBER'
                    sh 'docker push 510314780674.dkr.ecr.us-east-1.amazonaws.com/microservices:notification + $BUILD_NUMBER'
>>>>>>> parent of 7b0a98a (Coding jenkinsfile)
                }
            }
        }
        /* }
        stage('Install helm chart for mongo') {
            steps {
                sh 'helm install mongo ./helm_charts/MongoDB/'
            }      
        }
        stage('Install helm chart for postgres') {
            steps {
                sh 'helm install postgres ./helm_charts/Postgres/'
            }      
        }
        stage('Install helm chart for rabbitmq') {
            steps {
                sh 'helm install rabbitmq ./helm_charts/RabbitMQ/'
            }      
        } */
    }
}
