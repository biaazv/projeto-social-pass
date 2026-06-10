# SocialPass - Plataforma de Democratização da Atividade Física 🏋️‍♂️🏊‍♀️

O **SocialPass** é uma solução de impacto social baseada no modelo corporativo do Wellhub/Totalpass, porém voltada exclusivamente para a população hipossuficiente do município do Rio de Janeiro cadastrada no **CadÚnico**.

O projeto visa transformar a prática esportiva numa ferramenta de saúde preventiva e inclusão social, conectando cidadãos de áreas vulneráveis a vagas ociosas em academias e centros esportivos parceiros.

---

## 🚀 Escopo do MVP (Onda 1)

O desenvolvimento inicial está focado nas seguintes funcionalidades prioritárias (Baseado no Modelo Lógico V2):
1. **Validação Automatizada de Elegibilidade:** Integração com a API do CadÚnico via CPF/NIS.
2. **Gestão Cadastral:** Cadastro de usuários titulares e seus dependentes.
3. **Módulo de Academias Parceiras:** Cadastro de estabelecimentos e listagem de atividades/modalidades físicas disponíveis.
4. **Módulo de Agendamentos e Check-in:** Sistema de reserva de vagas por atividade e validação presencial via QR Code.

---

## 🛠️ Stack Tecnológica

* **Back-end:** Java Spring Boot 3 (API RESTful Segura)
* **Banco de Dados:** MySQL 8.0 / 8.4 (SGBD Relacional)
* **Front-end Web (Gestor/Academia):** React.js
* **Aplicativo Mobile (Cidadão):** React Native
* **Infraestrutura/Deploy:** Nuvem (AWS / GCP) em conformidade com as diretrizes da LGPD

---

## 📂 Estrutura do Repositório

```text
├── backend/                              # API Java Spring Boot 3
├── frontend/                             # Interface Web (HTML/JS/CSS)
├── database/                             # Scripts e documentação SQL
│   ├── docs/
│   │   └── DOCUMENTACAO_IMPLANTACAO.md   # Dicionário de dados e instruções de infra
│   ├── scripts/
│   │   ├── ddl_social_pass.sql           # Script de criação das tabelas
│   │   └── popula_banco.sql             # Script de carga inicial
├── AGENTS.md                             # Guia de execução e orientações para agentes
└── README.md                             # Este arquivo explicativo