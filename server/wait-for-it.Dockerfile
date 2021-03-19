######################################
# Base image for compiling container #
######################################
FROM node:lts-alpine as builder

# Define our work dir as /usr/src/app/
WORKDIR /usr/src/app/

# Copy dependency file
COPY package.json /usr/src/app/

# Install only needed dependencies for the application
RUN npm install --only=production

########################################
# Base image for application container #
########################################
FROM node:14

# Specify this variable for right execution of libraries in production mode
ENV NODE_ENV production

# Define our work dir as /usr/src/app/
WORKDIR /usr/src/app/

# install needed software
RUN apt-get update && apt-get install -y curl

# Download wait-for-it.sh script
RUN curl -LJO https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/src/app/wait-for-it.sh

# Copy node_modules folder with all installed dependencies in the compiling image
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules

# Copy application files
COPY src /usr/src/app/src

# Indicate exposed port by container
EXPOSE 3000

# Command that is executed when the container will be started
CMD ["node", "src/server.js"]
