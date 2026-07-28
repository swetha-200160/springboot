FROM eclipse-temurin:21-jdk

WORKDIR /app

# Build-time arguments
ARG PROJECT_PORT=8082
ARG ROOT_PATH=/java-app
ARG JAR_FILE=target/*.jar

# Copy the JAR
COPY ${JAR_FILE} app.jar

# Spring Boot configuration
ENV SERVER_PORT=${PROJECT_PORT}
ENV CONTEXT_PATH=${ROOT_PATH}

# OpenTelemetry configuration
ENV OTEL_SERVICE_NAME=springboot-app
ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://host.docker.internal:4317
ENV OTEL_EXPORTER_OTLP_PROTOCOL=grpc

# Expose application port
EXPOSE ${SERVER_PORT}

# Start Spring Boot
ENTRYPOINT ["sh","-c","java -jar app.jar --server.port=${SERVER_PORT} --server.servlet.context-path=${CONTEXT_PATH}"]