
cd eurekasvr
	if exist "target/*SNAPSHOT*.jar"  start "Eureka Server (1/8)" mvn spring-boot:run
	if not exist "target/*SNAPSHOT*.jar"  start "Eureka Server (1/8)" mvn clean package spring-boot:run
cd..

timeout 10

cd confsvr
	if exist "target/*SNAPSHOT*.jar" start "Config Server (2/8)" mvn spring-boot:run
	if not exist "target/*SNAPSHOT*.jar" start "Config Server (2/8)" mvn clean package spring-boot:run
cd..

timeout 30

cd zuulsvr
if not exist "target/*SNAPSHOT*.jar" call mvn clean package
start "Zuul Server (3/8)" java -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/zuulsvr-0.0.1-SNAPSHOT.jar
cd..

timeout 30

REM	docker pull spotify/kafka
REM docker run -d --rm -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=localhost --env ADVERTISED_PORT=9092 --name kafkaserver spotify/kafka
start "Kafka Server (4/8)" docker run -d --name="kafkaserver" --rm -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=localhost --env ADVERTISED_PORT=9092 spotify/kafka

timeout 30

REM	docker pull redis:alpine
REM	docker run -d -p 6379:6379 --name redis redis:alpine
REM start "" docker start redis
start "Redis Server (5/8)" docker run -d --name="redis" -p 6379:6379 redis:alpine
	
timeout 10

cd organization-service
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
start "Organization Service (6/8)" java -Dserver.port=8087  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/organization-service-0.0.1-SNAPSHOT.jar

cd..

timeout 10

cd licensing-service
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
start "Licensing Servcie (7/8)" java -Dserver.port=8080  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.1-SNAPSHOT.jar
cd..

timeout 10
	
REM	docker pull digitsy/kafka-magic
start "Kafka UI (8/8)" docker run -d --rm -p 6060:80 digitsy/kafka-magic
