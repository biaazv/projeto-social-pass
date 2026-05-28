# Documentação de Implantação do Banco de Dados - SocialPass (Versão 2.0)

Esta documentação fornece as diretrizes técnicas, arquiteturais e operacionais para a instalação, configuração e implantação da nova estrutura do banco de dados do projeto **SocialPass** no ambiente de Homologação e Produção.

## 1. Arquitetura e Escolha Tecnológica

O **SocialPass** utiliza o **MySQL (versão 8.0+)** como seu Sistema Gerenciador de Banco de Dados (SGBD) relacional principal.

### Justificativa Técnica das Mudanças (Modelo Granular):
* **Rastreabilidade e Auditoria:** A criação da tabela `Validacao_Cad_Unico` isola os logs de consulta à API externa do Ministério do Desenvolvimento Social (MDS), prevenindo sobrecarga na tabela principal de usuários.
* **Mitigação de Conflitos (Lotação):** A introdução das tabelas `Atividade` e `Agendamento` garante que o cidadão reserve sua vaga antes de comparecer ao local, otimizando a distribuição de fluxo nos horários ociosos das academias parceiras.
* **Segurança e LGPD:** Separação estrita dos dados cadastrais básicos (`Usuario`) dos dados de vulnerabilidade socioeconômica (`Cad_Unico`).

---

## 2. Dicionário de Dados (Estrutura das Tabelas)

### 2.1 Tabela: `Usuario`
Armazena os dados cadastrais básicos e de localização dos cidadãos titulares.
* `id_usuario` (INT, PK, Auto-Increment)
* `nome` (VARCHAR(255), NOT NULL)
* `cpf` (VARCHAR(14), UNIQUE, NOT NULL): Documento formatado para validação.
* `data_nascimento` (DATE, NOT NULL)
* `endereco` (VARCHAR(255))
* `bairro` (VARCHAR(100)): Crucial para a delimitação geográfica dos bairros piloto (Bangu, Madureira, Pavuna).
* `status` (VARCHAR(50)): Estado da conta do usuário (ex: ATIVO, INATIVO).
* `data_cadastro` (DATETIME)

### 2.2 Tabela: `Dependente`
Gerencia o vínculo familiar, permitindo que dependentes legais usufruam do benefício.
* `id_dependente` (INT, PK, Auto-Increment)
* `id_usuario` (INT, FK): Relacionamento com o Titular.
* `nome` (VARCHAR(255), NOT NULL)
* `cpf` (VARCHAR(14), UNIQUE)
* `data_nascimento` (DATE, NOT NULL)
* `parentesco` (VARCHAR(100))
* `status` (VARCHAR(50))

### 2.3 Tabela: `Academia`
Registra os estabelecimentos parceiros e suas coordenadas geográficas precisas.
* `id_academia` (INT, PK, Auto-Increment)
* `nome` (VARCHAR(255), NOT NULL): Nome fantasia da unidade.
* `endereco` (VARCHAR(255))
* `bairro` (VARCHAR(100))
* `latitude` (DOUBLE, NOT NULL): Coordenada para cálculo de raio de 1km.
* `longitude` (DOUBLE, NOT NULL): Coordenada para cálculo de raio de 1km.
* `telefone` (VARCHAR(50))
* `status` (VARCHAR(50))

### 2.4 Tabela: `Cad_Unico`
Entidade isolada para validação e cruzamento de dados de hipossuficiência.
* `id_cadunico` (INT, PK, Auto-Increment)
* `id_usuario` (INT, FK): Vínculo 1:1 ou 1:N com a tabela de usuários.
* `nis` (VARCHAR(20), UNIQUE, NOT NULL): Número de Identificação Social.
* `renda_familiar` (DECIMAL(10,2)): Utilizado para cálculo de indicadores de vulnerabilidade.
* `situacao` (VARCHAR(100)): Status do cadastro no Governo Federal.
* `data_validacao` (DATE)

### 2.5 Tabela: `Validacao_Cad_Unico`
Tabela transacional para histórico de auditoria e controle de requisições de API.
* `id_validacao` (INT, PK, Auto-Increment)
* `id_cadunico` (INT, FK): Referência ao registro do CadÚnico consultado.
* `data_consulta` (DATETIME)
* `resultado` (VARCHAR(255)): Sucesso, Falha de Comunicação, Dados Inconsistentes.
* `mensagem` (VARCHAR(255)): Resposta bruta/código de erro retornado pelo barramento governamental.
* `orgao_responsavel` (VARCHAR(100)): Identificação da entidade (ex: MDS, SMAS-RJ).

### 2.6 Tabela: `Atividade`
Especifica as modalidades e capacidades operacionais oferecidas por cada parceiro.
* `id_atividade` (INT, PK, Auto-Increment)
* `id_academia` (INT, FK): Academia que oferta a modalidade.
* `nome` (VARCHAR(255), NOT NULL): Ex: Natação, Jiu-Jitsu, Musculação.
* `descricao` (TEXT)
* `categoria` (VARCHAR(100))
* `duracao_minutos` (INT)
* `capacidade_maxima` (INT): Limite de alunos por sessão para evitar superlotação.
* `status` (VARCHAR(50))

### 2.7 Tabela: `Agendamento`
Controla as reservas prévias feitas pelos usuários no aplicativo.
* `id_agendamento` (INT, PK, Auto-Increment)
* `id_usuario` (INT, FK)
* `id_atividade` (INT, FK)
* `id_academia` (INT, FK)
* `data_agendamento` (DATE)
* `horario` (TIME)
* `status` (VARCHAR(50)): PENDENTE, CONFIRMADO, CANCELADO.
* `data_criacao` (DATETIME)

### 2.8 Tabela: `Checkin`
Gerencia a validação de presença do usuário em tempo real na recepção.
* `id_checkin` (INT, PK, Auto-Increment)
* `id_usuario` (INT, FK)
* `id_academia` (INT, FK)
* `id_agendamento` (INT, FK, Nullable): Permite rastrear se o check-in veio de uma reserva prévia.
* `data_hora` (DATETIME)
* `qr_code` (TEXT): String do token dinâmico gerado no celular.
* `status` (VARCHAR(50))

---

## 3. Script SQL de Execução Física (DDL Completo)

```sql
CREATE DATABASE IF NOT EXISTS socialpass_v2_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE socialpass_v2_db;

-- Tabela: Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario INT AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    data_nascimento DATE NOT NULL,
    endereco VARCHAR(255),
    bairro VARCHAR(100),
    status VARCHAR(50),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_cpf UNIQUE (cpf)
) ENGINE=InnoDB;

-- Tabela: Dependente
CREATE TABLE IF NOT EXISTS Dependente (
    id_dependente INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    data_nascimento DATE NOT NULL,
    parentesco VARCHAR(100),
    status VARCHAR(50),
    CONSTRAINT pk_dependente PRIMARY KEY (id_dependente),
    CONSTRAINT uq_dependente_cpf UNIQUE (cpf),
    CONSTRAINT fk_dependente_usuario
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela: Academia
CREATE TABLE IF NOT EXISTS Academia (
    id_academia INT AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    bairro VARCHAR(100),
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL,
    telefone VARCHAR(50),
    status VARCHAR(50),
    CONSTRAINT pk_academia PRIMARY KEY (id_academia)
) ENGINE=InnoDB;

-- Tabela: Cad_Unico
CREATE TABLE IF NOT EXISTS Cad_Unico (
    id_cadunico INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nis VARCHAR(20) NOT NULL,
    renda_familiar DECIMAL(10, 2),
    situacao VARCHAR(100),
    data_validacao DATE,
    CONSTRAINT pk_cad_unico PRIMARY KEY (id_cadunico),
    CONSTRAINT uq_cad_unico_nis UNIQUE (nis),
    CONSTRAINT fk_cad_unico_usuario
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela: Validacao_Cad_Unico
CREATE TABLE IF NOT EXISTS Validacao_Cad_Unico (
    id_validacao INT AUTO_INCREMENT,
    id_cadunico INT NOT NULL,
    data_consulta DATETIME DEFAULT CURRENT_TIMESTAMP,
    resultado VARCHAR(255),
    mensagem VARCHAR(255),
    orgao_responsavel VARCHAR(100),
    CONSTRAINT pk_validacao_cad_unico PRIMARY KEY (id_validacao),
    CONSTRAINT fk_validacao_cad_unico_cad
        FOREIGN KEY (id_cadunico) REFERENCES Cad_Unico (id_cadunico)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela: Atividade
CREATE TABLE IF NOT EXISTS Atividade (
    id_atividade INT AUTO_INCREMENT,
    id_academia INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100),
    duracao_minutos INT,
    capacidade_maxima INT,
    status VARCHAR(50),
    CONSTRAINT pk_atividade PRIMARY KEY (id_atividade),
    CONSTRAINT fk_atividade_academia
        FOREIGN KEY (id_academia) REFERENCES Academia (id_academia)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela: Agendamento
CREATE TABLE IF NOT EXISTS Agendamento (
    id_agendamento INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_atividade INT NOT NULL,
    id_academia INT NOT NULL,
    data_agendamento DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(50),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_agendamento PRIMARY KEY (id_agendamento),
    CONSTRAINT fk_agendamento_usuario
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_agendamento_atividade
        FOREIGN KEY (id_atividade) REFERENCES Atividade (id_atividade)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_agendamento_academia
        FOREIGN KEY (id_academia) REFERENCES Academia (id_academia)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela: Checkin
CREATE TABLE IF NOT EXISTS Checkin (
    id_checkin INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_academia INT NOT NULL,
    id_agendamento INT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    qr_code TEXT,
    status VARCHAR(50),
    CONSTRAINT pk_checkin PRIMARY KEY (id_checkin),
    CONSTRAINT fk_checkin_usuario
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_checkin_academia
        FOREIGN KEY (id_academia) REFERENCES Academia (id_academia)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_checkin_agendamento
        FOREIGN KEY (id_agendamento) REFERENCES Agendamento (id_agendamento)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Índices de Otimização
CREATE INDEX idx_academia_geo ON Academia (latitude, longitude);
CREATE INDEX idx_usuario_bairro ON Usuario (bairro);
CREATE INDEX idx_checkin_data ON Checkin (data_hora);
```


## ⚙️ Como Configurar e Executar o Banco de Dados (MySQL 8)

### Pré-requisitos:
* **MySQL Server 8.0+** instalado localmente, rodando como serviço ou via Docker.
* Um cliente SQL da sua preferência (DBeaver, MySQL Workbench ou a extensão VSCode SQLTools).

### Passo a Passo via Linha de Comando (VSCode Terminal):

1. **Clonar o repositório e navegar até a pasta dos scripts:**
   ```bash
   git clone [https://github.com/biaazv/projeto-social-pass.git](https://github.com/biaazv/projeto-social-pass.git)
   cd social_pass/database/scripts
   ```

2. **Criar e Inicializar a Estrutura Física do Banco de Dados:**
Execute o utilitário de linha de comando do MySQL apontando para o arquivo DDL.
Em sequência, para popular o banco de dados, executar o segundo comando.
 Substitua root pelo seu usuário do banco de dados:
    ```bash
    mysql -u root -p < ddl_social_pass.sql
    mysql -u root -p < popula_banco.sql
    ```