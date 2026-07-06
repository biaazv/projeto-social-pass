# SocialPass - Plataforma de Democratização da Atividade Física 🏋️‍♂️🏊‍♀️

O **SocialPass** é uma solução de impacto social baseada no modelo corporativo do Wellhub/Totalpass, porém voltada exclusivamente para a população hipossuficiente do município do Rio de Janeiro cadastrada no **CadÚnico**.

O projeto visa transformar a prática esportiva numa ferramenta de saúde preventiva e inclusão social, conectando cidadãos de áreas vulneráveis a vagas ociosas em academias e centros esportivos parceiros.

---

## 🚀 Escopo do MVP (Onda 1)

O desenvolvimento inicial está focado nas seguintes funcionalidades prioritárias:
1. **Validação Automatizada de Elegibilidade:** Integração com a API do CadÚnico via CPF/NIS.
2. **Gestão Cadastral:** Cadastro de usuários titulares e seus dependentes.
3. **Módulo de Academias Parceiras:** Cadastro, login e listagem de estabelecimentos parceiros.
4. **Módulo de Agendamentos e Check-in:** Sistema de reserva de vagas por atividade e validação presencial via QR Code.

---

## 🏁 Começando

Essas instruções permitirão que você obtenha uma cópia do projeto em operação na sua máquina local para fins de desenvolvimento e teste.

### 📋 Pré-requisitos

Você pode optar por executar o projeto de forma **Nativa** (instalando tudo na sua máquina) ou via **Docker** (recomendado para evitar instalações manuais).

#### Opção 1: Via Docker (Recomendado)
*   **Docker Desktop** instalado (inclui Docker Compose).

#### Opção 2: Execução Nativa
*   **Java 21**: JDK instalado e configurado.
*   **MySQL**: Versão 8.0 ou superior.
*   **Maven**: Para gerenciar dependências e build do backend (ou utilize o `./mvnw` incluso).
*   **Servidor de arquivos estáticos**: Para rodar o frontend (Python 3, Node.js `serve`, ou similar).

---

## 🐳 Execução via Docker (Rápida)

Esta é a forma mais simples de rodar o projeto completo sem instalar Java ou MySQL.

1.  Certifique-se de que o Docker está rodando.
2.  Na raiz do projeto, execute:
    ```bash
    docker-compose up --build
    ```
3.  O Docker irá:
    *   Subir um banco MySQL e inicializar as tabelas automaticamente.
    *   Compilar e rodar o Backend na porta `8080`.
    *   Servir o Frontend na porta `3000`.

**Acessos:**
*   Frontend: [http://localhost:3000](http://localhost:3000)
*   Backend (Swagger): [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)

---

## 🔧 Instalação Nativa (Manual)

Se preferir não usar Docker, siga os passos abaixo:

#### 1. Banco de Dados (MySQL)
*   **Nome do Banco:** `gympass_db`
*   **Scripts:** Localizados em `database/scripts/`.
*   **Execução:**
    ```bash
    # Acesse o MySQL e crie o banco
    mysql -u seu_usuario -p -e "CREATE DATABASE gympass_db;"

    # Execute o script de criação das tabelas (DDL)
    mysql -u seu_usuario -p gympass_db < database/scripts/ddl_social_pass.sql

    # (Opcional) Popule o banco com dados iniciais (DML)
    mysql -u seu_usuario -p gympass_db < database/scripts/popula_banco.sql
    ```

#### 2. Backend (Java Spring Boot)
*   **Configuração:** Verifique e ajuste as credenciais do banco em `backend/src/main/resources/application.properties`.
*   **Execução:**
    ```bash
    cd backend
    # Garanta permissão de execução para o wrapper do Maven
    chmod +x mvnw
    # Inicie a aplicação
    ./mvnw spring-boot:run
    ```

#### 3. Frontend (Web)
*   **Execução:** Utilize um servidor de arquivos estáticos na pasta `/frontend`.
    ```bash
    cd frontend && python3 -m http.server 3000
    # OU
    cd frontend && npx serve -p 3000
    ```

---

## ⚙️ Executando os testes

Para garantir que tudo esteja funcionando corretamente, execute os testes automatizados.

### 🔩 Analise os testes de integração e unitários
No diretório `backend`, execute:
```bash
./mvnw test
```

### ⌨️ Estilo de codificação
O código segue os padrões recomendados para projetos Spring Boot. Recomenda-se o uso de extensões de Lint na sua IDE.

---

## 📦 Implantação
Para implantar em um sistema ativo:
*   Configure as variáveis de ambiente necessárias (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`).
*   Utilize o `docker-compose.yml` como base para sua orquestração.

---

## 🛠️ Construído com

*   [Spring Boot 3](https://spring.io/projects/spring-boot) - Framework Java para Backend
*   [Spring Security](https://spring.io/projects/spring-security) - Autenticação e Hashing de Senhas (BCrypt)
*   [Maven](https://maven.apache.org/) - Gerenciador de Dependências
*   [MySQL](https://www.mysql.com/) - Banco de Dados Relacional
*   [Nginx](https://www.nginx.com/) - Servidor Web para o Frontend (via Docker)
*   [Spring Data JPA](https://spring.io/projects/spring-data-jpa) - Persistência de Dados
*   [SpringDoc OpenAPI](https://springdoc.org/) - Documentação Swagger (Swagger UI na porta 8080)
*   [Lombok](https://projectlombok.org/) - Produtividade e redução de código boilerplate

---

## 📂 Estrutura do Repositório

```text
├── backend/                              # API Java Spring Boot 3
├── frontend/                             # Interface Web (HTML/JS/CSS)
├── database/                             # Scripts e documentação SQL
│   ├── docs/                             # Dicionário de dados
│   └── scripts/                          # Scripts de criação e população
├── AGENTS.md                             # Guia de execução e orientações para agentes
├── docker-compose.yml                    # Orquestração de containers
└── README.md                             # Este arquivo explicativo
```

---

## 🖇️ Colaborando

Por favor, entre em contato para mais informações sobre o processo de envio de pull requests e o código de conduta.

## 📌 Versão

Nós usamos [SemVer](http://semver.org/) para controle de versão.

## 🎁 Expressões de gratidão

*   Conte a outras pessoas sobre este projeto 📢;
*   Um agradecimento publicamente 🫂;
*   Ajude a levar saúde para quem mais precisa! 🏊‍♂️
---
⌨️ com ❤️ por [Armstrong Lohãns](https://gist.github.com/lohhans) 😊
