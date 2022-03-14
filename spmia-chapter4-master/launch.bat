cd eurekasvr
	if exist "target/*SNAPSHOT*.jar"  start "Eureka Server (1/4)" mvn spring-boot:run
	if not exist "target/*SNAPSHOT*.jar"  start "Eureka Server (1/4)" mvn clean package spring-boot:run
cd..

timeout 10

cd confsvr
	if exist "target/*SNAPSHOT*.jar" start "Config Server (2/4)" mvn spring-boot:run
	if not exist "target/*SNAPSHOT*.jar" start "Config Server (2/4)" mvn clean package spring-boot:run
cd..

timeout 20

cd organization-service
if not exist "target/*SNAPSHOT*.jar" call mvn clean package
start "Organization Service (3/4)" java -Dserver.port=8085  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/organization-service-0.0.1-SNAPSHOT.jar
cd..

timeout 10

cd licensing-service
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
start "Licensing Servcie (4/4)" java -Dserver.port=8080  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.1-SNAPSHOT.jar
cd..

