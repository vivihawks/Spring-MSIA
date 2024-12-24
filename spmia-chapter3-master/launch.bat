
cd confsvr
	if not exist "target/*SNAPSHOT*.jar" call mvn clean package 
	start "Config Server (1/2)" mvn spring-boot:run
cd..

timeout 20

cd licensing-service
	if not exist "target/*SNAPSHOT*.jar"	call mvn clean package
	start "Licensing Servcie (2/2)" java -Dserver.port=8080  -Dspring.cloud.config.uri="http://localhost:8888" -jar target/licensing-service-0.0.1-SNAPSHOT.jar
cd..

