########################################
# Base image for application container #
########################################
FROM node:14.16

# Specify this variable for right execution of libraries in production mode
ENV NODE_ENV production

# Define our work dir as /usr/src/app/
WORKDIR /usr/src/app/

# Download wait-for-it.sh script
RUN curl -LJO https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/src/app/wait-for-it.sh

# Copy application files
COPY package.json /usr/src/app/
COPY src /usr/src/app/src
COPY public /usr/src/app/public
COPY config /usr/src/app/config

# Install only needed dependencies for the application
RUN npm install --only=production

# Indicate exposed port by container
EXPOSE 3000

# Command that is executed when the container will be started
CMD ["node", "src/server.js"]
