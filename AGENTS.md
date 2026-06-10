# SocialPass - Guia de Execução e Orientações

Este guia fornece instruções sobre como configurar e executar o projeto SocialPass de forma integrada.

## 🚀 Como Executar o Projeto

O projeto está dividido em três partes principais: Banco de Dados, Backend e Frontend.

### 1. Banco de Dados (MySQL)
O banco de dados deve ser configurado primeiro.
- **Nome do Banco:** `gympass_db`
- **Scripts:** Localizados em `database/scripts/`.
- **Execução:**
  1. Execute o script de criação: `mysql -u seu_usuario -p < database/scripts/ddl_social_pass.sql`
  2. (Opcional) Popule o banco: `mysql -u seu_usuario -p < database/scripts/popula_banco.sql`

### 2. Backend (Java Spring Boot)
O backend é uma API REST que se conecta ao MySQL.
- **Configuração:** Verifique as credenciais do banco em `backend/src/main/resources/application.properties`.
- **Execução:**
  1. Navegue até a pasta: `cd backend`
  2. Execute com Maven: `./mvnw spring-boot:run`
- **API Docs:** Após iniciar, acesse `http://localhost:8080/swagger-ui.html`.

### 3. Frontend (Web)
O frontend é composto por arquivos estáticos e agora reside na pasta raiz `/frontend`.
- **Execução:** Como o frontend é desacoplado, você pode serví-lo usando qualquer servidor de arquivos estáticos.
  - Exemplo com Python: `cd frontend && python3 -m http.server 3000`
  - Exemplo com Node (serve): `cd frontend && npx serve`
  - Ou simplesmente abrindo o arquivo `index.html` no navegador (embora um servidor seja recomendado).
- **Integração:** O frontend está configurado para se comunicar com o backend em `http://localhost:8080` por padrão (definido em `frontend/script.js`). Caso o backend rode em outra porta ou host, ajuste a variável `API_BASE_URL` no script.

---

## 🤖 Guia Jules (Agent Instructions)

Olá, Jules! Aqui estão as diretrizes para suas futuras atuações neste repositório:

### Estrutura do Projeto
- `/backend`: API Spring Boot. Siga os padrões de pacotes (controller, service, repository, entity).
- `/frontend`: Interface do usuário. Mantenha os arquivos organizados e evite colocar lógica de negócio complexa aqui; utilize a API.
- `/database`: Scripts SQL. Sempre que alterar uma entidade JPA, lembre-se de atualizar o `ddl_social_pass.sql`.

### Convenções
- **Banco de Dados:** Utilize sempre o nome `gympass_db`.
- **Entidades:** Mapeie corretamente os campos CamelCase do Java para snake_case no banco de dados quando necessário, ou garanta que os nomes coincidam.
- **Segurança:** Senhas devem ser tratadas com `BCryptPasswordEncoder`. O campo `senha` na entidade `Usuario` está marcado como `@JsonProperty(access = Access.WRITE_ONLY)`.
- **CORS:** Já existe uma configuração global em `backend/src/main/java/com/fullstack/gympass/config/CorsConfig.java`.

### Fluxo de Trabalho
1. Verifique as mudanças nas entidades Java.
2. Sincronize os scripts SQL em `database/scripts/`.
3. Verifique se o Frontend precisa de novos campos ou endpoints.
4. Teste a integração entre as camadas.
