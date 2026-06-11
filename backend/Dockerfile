# Estágio de Build
FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /app

# Copia o código fonte primeiro para garantir que o mvnw exista
COPY . .

# Garante permissão de execução e converte quebras de linha (caso necessário)
RUN chmod +x mvnw && sed -i 's/\r$//' mvnw

# Baixa as dependências e faz o build
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
