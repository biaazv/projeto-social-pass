# 🤖 Instruções para Agentes (Jules) - Projeto SocialPass

Este documento serve como a "Fonte da Verdade" para o desenvolvimento e manutenção do projeto SocialPass. Consulte este arquivo antes de realizar qualquer alteração para garantir consistência e evitar retrabalhos.

## 📂 Estrutura do Projeto

O projeto é um monorepo organizado em duas frentes principais:

- **`/backend`**: Aplicação Spring Boot (Java).
  - Gerenciado via Maven (`pom.xml`).
  - Utiliza o Maven Wrapper (`./mvnw`). Sempre dê permissão de execução (`chmod +x mvnw`) antes de rodar.
- **`/database`**: Artefatos SQL e documentação de dados.
  - O script principal é `database/scripts/ddl_social_pass.sql`.

## 🛠️ Stack Tecnológica

- **Linguagem**: Java 21.
- **Framework**: Spring Boot 3.4.0.
- **Segurança**: Spring Security 6+.
  - **IMPORTANTE**: Senhas **DEVEM** ser criptografadas usando `BCryptPasswordEncoder`. Nunca armazene ou manipule senhas em texto plano.
- **Banco de Dados**: MySQL 8+.
  - Nome padrão do banco: `socialpass_v2_db`.
- **API**: RESTful com documentação OpenAPI/Swagger (SpringDoc).

## 🗄️ Sincronização Backend x Banco de Dados

As entidades Java e as tabelas SQL estão sincronizadas. Ao alterar uma, a outra **deve** ser atualizada correspondentemente:

| Entidade Java | Tabela SQL | Campo Chave (Java -> SQL) |
| :--- | :--- | :--- |
| `Usuario` | `Usuario` | `nomeCompleto` -> `nome_completo`, `statusConta` -> `status_conta` |
| `Dependente` | `Dependente` | `idDependente` -> `id_dependente` |

## ⚙️ Configurações e Variáveis de Ambiente

O arquivo `backend/src/main/resources/application.properties` utiliza variáveis de ambiente com fallbacks para desenvolvimento local:

- `SPRING_DATASOURCE_URL`: `jdbc:mysql://localhost:3306/socialpass_v2_db`
- `SPRING_DATASOURCE_USERNAME`: `root`
- `SPRING_DATASOURCE_PASSWORD`: `1234`

**NÃO remova os fallbacks** a menos que solicitado expressamente, para garantir que o projeto continue rodando localmente sem configurações complexas.

## 🚀 Comandos Rápidos

- **Compilar e Testar**: `cd backend && ./mvnw clean compile test`
- **Rodar Local**: `cd backend && ./mvnw spring-boot:run`
- **Verificar Frontend Estático**: `backend/src/main/resources/static/social-pass/index.html`

## 📝 Diretrizes de Desenvolvimento

1. **Naming**: O projeto foi migrado de "Gympass" para "SocialPass". Use "socialpass" em novos pacotes, artefatos ou variáveis.
2. **Refatoração**: Evite reverter mudanças de segurança (como a inclusão do Spring Security) ou downgrade de versões do Spring Boot sem uma justificativa técnica clara.
3. **Frontend**: O frontend estático atual é simples e reside em `src/main/resources/static`. Alterações visuais devem ser validadas via Playwright quando possível.
