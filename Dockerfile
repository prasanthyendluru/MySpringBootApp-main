# -------- Build stage (uses Maven image, no mvnw needed) --------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom first to cache dependencies
COPY pom.xml .
RUN mvn -q -B -DskipTests dependency:go-offline

# Now copy sources and build the jar
COPY src ./src
RUN mvn -q -B -DskipTests package

# -------- Runtime stage (small JRE image) --------
FROM eclipse-temurin:17-jre
WORKDIR /app
# copy whatever jar was built
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
