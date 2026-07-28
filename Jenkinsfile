pipeline {
    agent any

    tools {
        maven 'Maven-3.9.16'
    }

    environment {
        IMAGE_NAME = 'springboot-monitoring'
        CONTAINER_NAME = 'springboot-app'
        APP_PORT = '8082'

        // OpenTelemetry
        OTEL_SERVICE_NAME = 'springboot-app'
        OTEL_EXPORTER_OTLP_ENDPOINT = 'http://host.docker.internal:4317'
        OTEL_EXPORTER_OTLP_PROTOCOL = 'grpc'
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

        stage('Run Docker Container with OTEL') {
            steps {
                bat '''
                    docker run -d --name %CONTAINER_NAME% ^
                    -p %APP_PORT%:8080 ^
                    -e OTEL_SERVICE_NAME=%OTEL_SERVICE_NAME% ^
                    -e OTEL_EXPORTER_OTLP_ENDPOINT=%OTEL_EXPORTER_OTLP_ENDPOINT% ^
                    -e OTEL_EXPORTER_OTLP_PROTOCOL=%OTEL_EXPORTER_OTLP_PROTOCOL% ^
                    %IMAGE_NAME%
                '''
            }
        }

        stage('Application Health Check') {
            steps {
                bat '''
                    echo Waiting for Spring Boot application...
                    ping 127.0.0.1 -n 10 > nul
                    curl -f http://localhost:%APP_PORT%/java-app/actuator/health
                '''
            }
        }

        stage('Verify Prometheus Metrics') {
            steps {
                bat 'curl http://localhost:%APP_PORT%/java-app/actuator/prometheus'
            }
        }

        stage('Verify OTel Collector') {
             steps {
                 bat 'curl -f http://localhost:4318/v1/traces' 
                 } 
        }

        stage('Verify Grafana') {
            steps {
                bat 'curl -f http://localhost:3000/api/health'
            }
        }
    }

    post {
        success {
            echo 'Application deployed successfully.'
            echo 'Prometheus metrics endpoint is available.'
            echo 'OpenTelemetry is configured.'
            echo 'Open Grafana to view dashboards.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}