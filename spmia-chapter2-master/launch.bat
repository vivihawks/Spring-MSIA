cd licensing-service
if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
#start "Licensing Service (1/1)" java -Dserver.port=8080  -Deureka.client.serviceUrl.defaultZone="http://localhost:8761/eureka" -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.1-SNAPSHOT.jar
start "Licensing Service (1/1)" java -Dserver.port=8080  -jar target/licensing-service-0.0.1-SNAPSHOT.jar
