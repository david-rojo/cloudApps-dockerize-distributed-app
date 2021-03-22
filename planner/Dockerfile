######################################
# Base image for compiling container #
######################################
FROM maven:3.6.3-openjdk-11 as builder

# Define workdir where commands will be executed
WORKDIR /project

# Copy project dependencies
COPY pom.xml /project/

# Download project dependencies
RUN mvn clean verify --fail-never 

# Copy project code
COPY src /project/src

# Compile project
# is not possible to use the commented command with -o because in build section of pom, is launched a rebuild and 
# com.google.protobuf:protoc:exe:linux-x86_64:3.10.0 dependency is missing, so is needed to connecto to download it
# RUN mvn package -o
# But the rest of the dependencies are downloaded with mvn clean verify --fail-never command
RUN mvn package

########################################
# Base image for application container #
########################################
FROM openjdk:11-jre-slim

# Define work dir where JAR will be located
WORKDIR /usr/src/app/

# Copy JAR from compiling container
COPY --from=builder /project/target/*.jar /usr/src/app/

# Command executed with docker run
CMD [ "java", "-jar", "planner.jar" ]