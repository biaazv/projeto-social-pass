# SocialPass - Plataforma de Democratização da Atividade Física 🏋️‍♂️🏊‍♀️


O **SocialPass** é uma solução de impacto social baseada no modelo corporativo do Wellhub/Totalpass, porém voltada exclusivamente para a população hipossuficiente do município do Rio de Janeiro cadastrada no **CadÚnico**. 

O projeto visa transformar a prática esportiva numa ferramenta de saúde preventiva e inclusão social, conectando cidadãos de áreas vulneráveis a vagas ociosas em academias e centros esportivos parceiros.

---

## 🏗️ Estrutura do Projeto Unificado

Este repositório consolidado contém tanto o backend quanto a estrutura de banco de dados, organizados da seguinte forma:

```text
├── backend/                  # API REST desenvolvida em Java/Spring Boot
│   ├── src/main/java         # Código fonte das classes Java
│   ├── src/main/resources    # Arquivos de configuração e recursos estáticos
│   └── pom.xml               # Gerenciador de dependências Maven
├── database/                 # Artefatos do Banco de Dados
│   ├── docs/                 # Documentação e diagramas (Modelo ER)
│   └── scripts/              # Scripts SQL para criação (DDL) e carga (DML)
└── README.md                 # Documentação principal
```

---

## 🛠️ Stack Tecnológica (Implementada)

* **Backend:** Java 21 com Spring Boot 3.4.0
* **Segurança:** Spring Security com criptografia de senhas (BCrypt)
* **Banco de Dados:** MySQL 8.0+ (Gerenciado via Spring Data JPA)
* **Documentação de API:** SpringDoc OpenAPI / Swagger UI
* **Build Tool:** Maven 3+

---

## 🚀 Como Executar

### 1. Banco de Dados
Execute o script de criação localizado em `database/scripts/ddl_social_pass.sql` no seu servidor MySQL local ou remoto.

### 2. Backend
O backend utiliza variáveis de ambiente para conexão com o banco de dados. Se não forem fornecidas, ele usará os valores padrão de desenvolvimento local.

Variáveis suportadas:
- `SPRING_DATASOURCE_URL` (Padrão: `jdbc:mysql://localhost:3306/socialpass_v2_db`)
- `SPRING_DATASOURCE_USERNAME` (Padrão: `root`)
- `SPRING_DATASOURCE_PASSWORD` (Padrão: `1234`)

Para rodar o projeto:
```bash
cd backend
./mvnw spring-boot:run
```

### 3. Acesso à Documentação
Após iniciar o servidor, a documentação interativa da API (Swagger) estará disponível em:
`http://localhost:8080/swagger-ui.html`

---

## 🚀 Escopo do MVP (Onda 1)

O desenvolvimento inicial está focado nas seguintes funcionalidades prioritárias:
1. **Validação Automatizada de Elegibilidade:** Integração com a API do CadÚnico via CPF/NIS.
2. **Gestão Cadastral:** Cadastro de usuários titulares e seus dependentes.
3. **Módulo de Academias Parceiras:** Cadastro de estabelecimentos e listagem de atividades/modalidades físicas disponíveis.
4. **Módulo de Agendamentos e Check-in:** Sistema de reserva de vagas por atividade e validação presencial via QR Code.

---

## 🛡️ Segurança e Conformidade
- Armazenamento seguro de senhas através de algoritmos de hashing forte.
- Configuração de CORS pronta para integração com frontend.
- Preparado para conformidade com as diretrizes da LGPD.
