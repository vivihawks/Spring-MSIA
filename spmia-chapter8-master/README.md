# Introduction
Welcome to Spring Microservices in Action, Chapter 8.  Chapter 8 demonstrates how to use Spring Cloud Stream messaging to asynchronously communicate messages between Spring Boot services. For this chapter, we will use Kafka as our message bus to transport messages between our services.

By the time you are done reading this chapter you will have built and/or deployed:

1.  A Spring Cloud Config server that is deployed as Docker container and can manage a services configuration information using a file system or GitHub-based repository.
2.  A Eureka server running as a Spring-Cloud based service.  This service will allow multiple service instances to register with it.  Clients that need to call a service will use Eureka to lookup the physical location of the target service.
3.  A Zuul API Gateway.  All of our microservices can be routed through the gateway and have pre, response and
post policies enforced on the calls.
4.  A organization service that will manage organization data used within EagleEye.
5.  A new version of the organization service.  This service is used to demonstrate how to use the Zuul API gateway to route to different versions of a service.
6.  A special routes services that the the API gateway will call to determine whether or not it should route a user's service call to a different service then the one they were originally calling.  This service is used in conjunction with the orgservice-new service to determine whether a call to the organization service gets routed to an old version of the organization service vs. a new version of the service.
7.  A licensing service that will manage licensing data used within EagleEye.
8.  A Postgres SQL database used to hold the data for these two services.
9.  A Kafka message bus to transport messages between services.
10. A Redis service to act as a distributed cache.

# Software needed
1.	Apache Maven (http://maven.apache.org). I used version 3.3.9 of the Maven. I chose Maven because, while other build tools like Gradle are extremely popular, Maven is still the pre-dominate build tool in use in the Java ecosystem. All of the code examples in this book have been compiled with Java version 1.8.
2.	Docker (http://docker.com). I built the code examples in this book using Docker V1.12 and above. I am taking advantage of the embedded DNS server in Docker that came out in release V1.11. New Docker releases are constantly coming out so it's release version you are using may change on a regular basis.
3.	Git Client (http://git-scm.com). All of the source code for this book is stored in a GitHub repository. For the book, I used version 2.8.4 of the git client.

# Building the Docker Images for Chapter 8
To build the code examples for Chapter 8 as a docker image, open a command-line window change to the directory where you have downloaded the chapter 8 source code.

Run the following maven command.  This command will execute the [Spotify docker plugin](https://github.com/spotify/docker-maven-plugin) defined in the pom.xml file.  

   **mvn clean package docker:build**

This is the first chapter we will have multiple Spring projects that need to be be built and compiled.  Running the above command at the root of the project directory will build all of the projects.  If everything builds successfully you should see a message indicating that the build was successful.

# Running the services in Chapter 8

Now we are going to use docker-compose to start the actual image.  To start the docker image,
change to the directory containing  your chapter 8 source code.  Issue the following docker-compose command:

   **docker-compose -f docker/common/docker-compose.yml up**

If everything starts correctly you should see a bunch of Spring Boot information fly by on standard out.  At this point all of the services needed for the chapter code examples will be running.



# Running on Tomcat

- 1. Launch the eureka server directly, by running ** mvn clean package spring-boot:run ** from the project root
- 2. Launch the config server directly, by running ** mvn clean package spring-boot:run ** from the project root
- 3. Launch the zuul server by running the following commands in the application root

	mvn clean package 
	java -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/zuulsvr-0.0.1-SNAPSHOT.jar 

- 4. Launch Kafka server as a Docker container image. The image is packaged with zookeeper that is mandatory to run kafka. 
	
	Manually start Docker Desktop and then issue the below commands
	docker pull spotify/kafka
	docker run -d -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=localhost --env ADVERTISED_PORT=9092 --name kafkaserver spotify/kafka
	
- If you already have that image in your docker local repo, then issue the below command
	
	docker run kafkaserver

- 5. Launch Redis server as a Docker container image. 
	
	docker pull redis:alpine
	docker run -d -p 6379:6379 --name redis redis:alpine

- If you already have that image in your docker local repo, then issue the below command
	
	docker run redis
	
- 6. Launch the organizationservice using the below commands. These commands let the server ports be changed dynamically, thus enabling ability to launch multiple instances. Tweak the ports for each service instance before issuing the command

	mvn clean package
	java -Dserver.port=8085  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/organization-service-0.0.1-SNAPSHOT.jar

- 7. Launch the licenseservice using the below commands. These commands let the server ports be changed dynamically, thus enabling ability to launch multiple instances. Tweak the ports for each service instance before issuing the command

	mvn clean package
	java -Dserver.port=8080  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.1-SNAPSHOT.jar

- 8. Optionally, Launch Kafka UI tool to monitor the Kafka Queues using the below docker commands
	
	docker pull digitsy/kafka-magic
	docker run -d --rm -p 6060:80 digitsy/kafka-magic

	*Remember to register localhost as host.docker.internal
	
If everything starts correctly you should see a bunch of Spring Boot information fly by on standard out.  At this point all of the services needed for the chapter code examples will be running.
	
-9. To test the application, open Postmand and fire a
	- PUT request to
	- http://localhost:5555/api/organization/v1/organizations/e254f8c-c442-4ebe-a82a-e2fc1d1ff78a
	- with the following json data in the payload body
	
		{
			"contactEmail": "mark.balster@custcrmco.com",
			"contactName": "Mark Balster",
			"contactPhone": "823-555-2222",
			"id": "e254f8c-c442-4ebe-a82a-e2fc1d1ff78a",
			"name": "customer-crm-co"
			}
-10. To check if change above was indded made, make a GET request to the same URL
	- http://localhost:5555/api/organization/v1/organizations/e254f8c-c442-4ebe-a82a-e2fc1d1ff78a
	
-11. To verify that the message of the above UPDATE was indeed exchanged, access the license service at the below  URL and observe the response object for Org details. You will see the change propagated
	- http://localhost:5555/api/licensing/v1/organizations/e254f8c-c442-4ebe-a82a-e2fc1d1ff78a/licenses/f3831f8c-c338-4ebe-a82a-e2fc1d1ff78a

