######################################
# Base image for compiling container #
######################################
FROM maven:3.6.3-openjdk-11 as builder

# Define workdir where commands will be executed
WORKDIR /project

# Copy project dependencies
COPY pom.xml /project/

# Download project dependencies
RUN mvn clean verify

# Copy project code
COPY src /project/src

# Compile project
# not working with -o, missing POM for com.google.protobuf:protoc:exe:linux-x86_64:3.10.0
#RUN mvn package -o
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
CMD [ "java", "-jar", "planner-0.0.1-SNAPSHOT.jar" ]