# Introduction
Welcome to Spring Microservices in Action, Chapter 4.  Chapter 4 builds on the material from Chapter 3 and introduces the concept of service registration and discovery patterns using Spring Cloud and Netflix's Eureka server.  Using service discovery, you will be able to add and remove service instances without the clients having to know the physical locations of the service.

By the time you are done reading this chapter you will have built and/or deployed:

1.  A Spring Cloud Config server that is deployed as Docker container and can manage a services configuration information using a file system or GitHub-based repository.
2.  A Eureka server running as a Spring-Cloud based service.  This service will allow multiple service instances to register with it.  Clients that need to call a service will use Eureka to lookup the physical location of the target service.
2.  A organization service that will manage organization data used within EagleEye.
3.  A licensing service that will manage licensing data used within EagleEye.
4.  A Postgres SQL database used to hold the data for these two services.

# Software needed
1.	Apache Maven (http://maven.apache.org). I used version 3.3.9 of the Maven. I chose Maven because, while other build tools like Gradle are extremely popular, Maven is still the pre-dominate build tool in use in the Java ecosystem. All of the code examples in this book have been compiled with Java version 1.8.
2.	Docker (http://docker.com). I built the code examples in this book using Docker V1.12 and above. I am taking advantage of the embedded DNS server in Docker that came out in release V1.11. New Docker releases are constantly coming out so it's release version you are using may change on a regular basis.
3.	Git Client (http://git-scm.com). All of the source code for this book is stored in a GitHub repository. For the book, I used version 2.8.4 of the git client.

# Building the Docker Images for Chapter 4
To build the code examples for Chapter 4 as a docker image, open a command-line window change to the directory where you have downloaded the chapter 4 source code.

Run the following maven command.  This command will execute the [Spotify docker plugin](https://github.com/spotify/docker-maven-plugin) defined in the pom.xml file.  

   **mvn clean package docker:build**

Running the above command at the root of the project directory will build all of the projects.  If everything builds successfully you should see a message indicating that the build was successful.

# Running the services in Chapter 3

Now we are going to use docker-compose to start the actual image.  To start the docker image,
change to the directory containing  your chapter 4 source code.  Issue the following docker-compose command:

   **docker-compose -f docker/common/docker-compose.yml up**

If everything starts correctly you should see a bunch of Spring Boot information fly by on standard out.  At this point all of the services needed for the chapter code examples will be running.


# Running on Tomcat

- 1. Launch the eureka server directly, by running ** mvn clean package spring-boot:run ** from the project root
- 2. Launch the config server directly, by running ** mvn clean package spring-boot:run ** from the project root
- 3. Launch the licenseservice using the below commands. These commands let the server ports be changed dynamically, thus enabling ability to launch multiple instances. Tweak the ports for each service instance before issuing the command. 

** mvn clean package **
** java -Dserver.port=8080  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.2-SNAPSHOT.jar **

- 4. Launch the organizationservice using the below commands. These commands let the server ports be changed dynamically, thus enabling ability to launch multiple instances. Tweak the ports for each service instance before issuing the command

** mvn clean package **
** java -Dserver.port=8085  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/organization-service-0.0.1-SNAPSHOT.jar **

- 5. To see the Eureka dashboard, hit the following url
	 
	 http://localhost:8761

- 6. To see all the instances of a service, hit the following GET endpoint. Default output is xml, which can be negotiated into json using the accept header
	 
	 http://localhost:8761/eureka/apps/<APPID>

- 7. To experiment with the clients, hit the below url. Client types below is one of Discovery, Rest or Feign 
	 
http://localhost:8080/v1/organizations/e254f8c-c442-4ebe-a82a-e2fc1d1ff78a/licenses/f3831f8c-c338-4ebe-a82a-e2fc1d1ff78a/feign
http://localhost:8080/v1/organizations/e254f8c-c442-4ebe-a82a-e2fc1d1ff78a/licenses/f3831f8c-c338-4ebe-a82a-e2fc1d1ff78a/discovery
http://localhost:8080/v1/organizations/e254f8c-c442-4ebe-a82a-e2fc1d1ff78a/licenses/f3831f8c-c338-4ebe-a82a-e2fc1d1ff78a/rest





If everything starts correctly you should see a bunch of Spring Boot information fly by on standard out.  At this point all of the services needed for the chapter code examples will be running.


