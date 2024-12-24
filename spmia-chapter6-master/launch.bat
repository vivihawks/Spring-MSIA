cd eurekasvr
	if exist "target/*SNAPSHOT*.jar"  start "Eureka Server (1/7)" mvn spring-boot:run
	if not exist "target/*SNAPSHOT*.jar"  start "Eureka Server (1/7)" mvn clean package spring-boot:run
cd..

timeout 10

cd confsvr
	if exist "target/*SNAPSHOT*.jar" start "Config Server (2/7)" mvn spring-boot:run
	if not exist "target/*SNAPSHOT*.jar" start "Config Server (2/7)" mvn clean package spring-boot:run
cd..

timeout 10

cd zuulsvr
if not exist "target/*SNAPSHOT*.jar" call mvn clean package
start "Zuul Server (3/7)" java -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/zuulsvr-0.0.1-SNAPSHOT.jar
cd..

timeout 30

cd organization-service
if not exist "target/*SNAPSHOT*.jar" call mvn clean package
start "Organization Service (4/7)" java -Dserver.port=8085  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/organization-service-0.0.1-SNAPSHOT.jar
cd..

timeout 10

cd orgservice-new
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
start "Organization Service New (5/7)" java -Dserver.port=8087  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/orgservice-new-0.0.1-SNAPSHOT.jar 
cd..

timeout 10

cd licensing-service
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
start "Licensing Servcie (6/7)" java -Dserver.port=8080  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.1-SNAPSHOT.jar
cd..

timeout 10

cd specialroutes-service
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
start "Special Routes Service (7/7)" java -Dserver.port=8090  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/specialroutesservice-0.0.1-SNAPSHOT.jar
cd..
