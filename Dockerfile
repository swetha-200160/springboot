FROM eclipse-temurin:21-jdk

WORKDIR /app

# Build-time arguments
ARG PROJECT_PORT=8080
ARG ROOT_PATH=/java-app
ARG JAR_FILE=target/*.jar

# Copy the JAR
COPY ${JAR_FILE} app.jar

# Environment variables
ENV SERVER_PORT=${PROJECT_PORT}
ENV CONTEXT_PATH=${ROOT_PATH}

# Expose the port
EXPOSE ${SERVER_PORT}

# Start Spring Boot
ENTRYPOINT ["sh","-c","java -jar app.jar --server.port=${SERVER_PORT} --server.servlet.context-path=${CONTEXT_PATH}"]