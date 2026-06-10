# Estágio de Build
FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /app

# Copia o wrapper do maven e o arquivo pom.xml
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
# Baixa as dependências (em cache se o pom.xml não mudar)
RUN ./mvnw dependency:go-offline

# Copia o código fonte e realiza o build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Estágio de Execução
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copia o jar gerado do estágio de build
COPY --from=build /app/target/*.jar app.jar

# Expõe a porta do Spring Boot
EXPOSE 8080

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
