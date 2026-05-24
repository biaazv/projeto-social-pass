-- COMANDO PARA EXECUTAR NO TERMINAL:
-- mysql -u root -p < ddl_social_pass.sql
-- -----------------------------------------------------
-- Criação do Banco de Dados - SocialPass (Baseado na Imagem)
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS socialpass_v2_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE socialpass_v2_db;

-- 1. Tabela: Usuario
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

-- 2. Tabela: Dependentes (Nome mapeado na imagem como "Dependente")
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

-- 3. Tabela: Academia
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

-- 4. Tabela: Cad_Unico
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

-- 5. Tabela: Validacao_Cad_Unico
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

-- 6. Tabela: Atividade
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

-- 7. Tabela: Agendamento
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

-- 8. Tabela: Checkin
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

-- -----------------------------------------------------
-- Índices Otimizadores para Coleção de Métricas e Geolocalização
-- -----------------------------------------------------
CREATE INDEX idx_academia_geo ON Academia (latitude, longitude);
CREATE INDEX idx_usuario_bairro ON Usuario (bairro);
CREATE INDEX idx_checkin_data ON Checkin (data_hora);