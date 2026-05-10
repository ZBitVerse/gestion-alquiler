# Etapa 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests
RUN find target/ -maxdepth 1 -name "*.jar" ! -name "*-plain.jar" -exec cp {} /app/eureka.jar \;

# Etapa 2: Run
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/eureka.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java", "-jar", "/app.jar"]