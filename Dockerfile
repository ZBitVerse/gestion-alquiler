# Etapa 1: Construcción (Build)
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
# Descarga las dependencias primero para que se guarden en caché
RUN mvn dependency:go-offline -B
COPY src ./src/
# Ahora el paquete se compila usando las dependencias ya descargadas
RUN mvn clean package -DskipTests
# Buscamos el JAR ejecutable (excluyendo el 'plain') y lo renombramos para que la copia sea segura
RUN find target/ -maxdepth 1 -name "*.jar" ! -name "*-plain.jar" -exec cp {} /app/main.jar \;

# Etapa 2: Ejecución (Run)
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/main.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
