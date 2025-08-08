## Run the application
```bash
mvn spring-boot:run
```

## Access
Open browser: http://localhost:8080

### To create executable JAR:
```bash
mvn clean package
# Creates: target/simple-hello-1.0.0.jar
```

The JAR file can then be run independently:
```bash
java -jar target/simple-hello-1.0.0.jar
```
