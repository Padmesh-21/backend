# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copy pom.xml first for better caching
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src src

# Build the application and skip tests
RUN mvn clean package -DskipTests -B

# Debug: Show what was built
RUN echo "Contents of target directory:" && ls -la target/

# Expose the port your app runs on
EXPOSE 8080

# Run the jar file - use a more flexible approach
CMD ["sh", "-c", "java -jar target/*.jar"]
