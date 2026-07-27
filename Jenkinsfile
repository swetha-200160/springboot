pipeline {

    agent any

    tools {
        maven 'Maven-3.9.16'
    }

    environment {
        IMAGE_NAME = "springboot-monitoring"
        CONTAINER_NAME = "springboot-app"
        APP_PORT = "8082"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Unit Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Stop Old Container') {
            steps {
                bat '''
                docker rm -f %CONTAINER_NAME% || exit 0
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                bat 'docker run -d --name %CONTAINER_NAME% -p %APP_PORT%:8080 %IMAGE_NAME%'
            }
        }

        stage('Application Health Check') {
            steps {
                bat 'curl http://localhost:%APP_PORT%/java-app/actuator/health'
            }
        }

        stage('Verify Prometheus Metrics') {
            steps {
                bat 'curl http://localhost:%APP_PORT%/java-app/actuator/prometheus'
            }
        }

    }   // <-- This closes stages block

    post {

        success {
            echo 'Application deployed successfully.'
            echo 'Prometheus metrics endpoint is available.'
            echo 'Open Grafana to view dashboards.'
        }

        failure {
            echo 'Pipeline failed.'
        }

    }   // <-- This closes post block

}       // <-- This closes pipeline