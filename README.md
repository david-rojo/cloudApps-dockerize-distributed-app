# Dockerizing EoloPlanner

This project is a distributed application composed by several services that communicate with each other using REST API, gRPC and RabbitMQ. The application exposes a web interface that communicates with the server with REST API and WebSockets. 

Some services are implemented with Node.js/Express and others with Java/Spring.

All mentioned services are going to be dockerized, so in order to run this project is needed to have [docker](https://docs.docker.com/engine/install/ubuntu/) and [docker compose](https://docs.docker.com/compose/install/) installed on your computer.

## Architecture

![ARCHITECTURE](doc/diagram/architecture-eolo-planner-dockerized.jpg)

## Building and publishing docker images in dockerhub

Is possible to change the account where docker images will be pushed in dockerhub, current value is my account, but if you want to upload them to yours, just change the value for ```DOCKERHUB_NAME``` var inside the  [build-publish-docker-images.sh](build-publish-docker-images.sh) script.

If you wish to run the script, you need to have [Pack](https://buildpacks.io/docs/tools/pack/) installed on your computer.

To build server, planner, toposervice and weatherservice docker images and push them to dockerhub, just execute:

```sh
$ ./build-publish-docker-images.sh
```

As it can be seen in the script, ```latest``` and ```1.0``` versions of each service are built and uploaded.

## Changes applied

* **Server**
  * Get connection values from environment variables in [amqpConnection.js](server/src/connections/amqpConnection.js) and [mysqlConnection.js](server/src/connections/mysqlConnection.js).
  * Wait to database will be ready is implemented in [Dockerfile](server/Dockerfile) with [wait-for-it.sh](https://github.com/vishnubob/wait-for-it) usage

* **Planner**
  * Get connection values from environment variables in [application.properties](planner/src/main/resources/application.properties) and [TopoClient.java](planner/src/main/java/es/codeurjc/mastercloudapps/planner/clients/TopoClient.java).
  * Docker image created using a multistage [Dockerfile](planner/Dockerfile) caching maven libraries.

* **Toposervice**
  * Get connection values from environment variables in [application.properties](toposervice/src/main/resources/application.properties).
  * Implement by code waiting to the mongo database will be ready and then launch the application:
  
  [*pom.xml*](toposervice/pom.xml)
  ```
  <dependency>
    <groupId>org.springframework.retry</groupId>
    <artifactId>spring-retry</artifactId>
  </dependency>
  ```
  
  [*Application.java*](toposervice/src/main/java/es/codeurjc/mastercloudapps/topo/Application.java)
  ```
  @SpringBootApplication
  public class Application {

	public static void main(String[] args) {
	
		RetryTemplate template = new RetryTemplate();
		AlwaysRetryPolicy policy = new AlwaysRetryPolicy();
		template.setRetryPolicy(policy);
		template.execute(context -> {
			SpringApplication.run(Application.class, args);
			return true;
		});
	}
  ```
  * Docker image created using [JIB](https://github.com/GoogleContainerTools/jib).
  
* **Weatherservice**

  * Get connection values from environment variables in [server.js](weatherservice/src/server.js).
  * Include ```start``` command in ```scripts``` attribute in [package.json](weatherservice/package.json) with value ```node src/server.js``` in order that the application can be started when the container will be launched.
  * Docker image created using [buildpacks](https://buildpacks.io/).

## Launch the application (production)

Also is provided [docker-compose-prod.yml](docker-compose-prod.yml) file in order to launch whole application. This file orchestrates the startup of the containers and it can be executed:

```sh
$ docker-compose -f docker-compose-prod.yml up
```

Environment variables values are provided in ```prod.env``` file

When the application will be ready, web interface can be reached in: [http://localhost:3000/](http://localhost:3000/)

![WEBAPP](doc/eolo-planner-app.jpg)

Progress of the applied operations in the web application can be checked in containers logs.

## Author

[David Rojo (@david-rojo)](https://github.com/david-rojo)
