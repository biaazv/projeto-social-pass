-- COMANDO PARA EXECUTAR NO TERMINAL:
-- mysql -u root -p < ddl_social_pass.sql
-- -----------------------------------------------------
-- Criação do Banco de Dados - SocialPass
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS gympass_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gympass_db;

-- 1. Tabela: usuario
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT,
    nome_completo VARCHAR(255) NOT NULL,
    nome_usuario VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    status_conta VARCHAR(30) NOT NULL,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_cpf UNIQUE (cpf),
    CONSTRAINT uq_usuario_email UNIQUE (email),
    CONSTRAINT uq_usuario_nome_usuario UNIQUE (nome_usuario)
) ENGINE=InnoDB;

-- 2. Tabela: dependente
CREATE TABLE IF NOT EXISTS dependente (
    id_dependente INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14),
    data_nascimento DATE NOT NULL,
    parentesco VARCHAR(100),
    status VARCHAR(50),
    CONSTRAINT pk_dependente PRIMARY KEY (id_dependente),
    CONSTRAINT uq_dependente_cpf UNIQUE (cpf),
    CONSTRAINT fk_dependente_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Tabela: academia
CREATE TABLE academia (
                          id_academia INT AUTO_INCREMENT PRIMARY KEY,
                          nome VARCHAR(150) NOT NULL,
                          endereco VARCHAR(255) NOT NULL,
                          bairro VARCHAR(100) NOT NULL,
                          cep VARCHAR(8),
                          cnpj VARCHAR(14) NOT NULL UNIQUE,
                          telefone VARCHAR(20) NOT NULL,
                          email VARCHAR(255) NOT NULL UNIQUE,
                          dias_funcionamento VARCHAR(30) NOT NULL,
                          horario_abertura TIME NOT NULL,
                          horario_fechamento TIME NOT NULL,
                          horario_funcionamento VARCHAR(120) NOT NULL,
                          possui_vestiario BOOLEAN NOT NULL,
                          status VARCHAR(20) NOT NULL,
                          senha VARCHAR(255) NOT NULL,
                          data_cadastro DATETIME NOT NULL,
                          data_atualizacao DATETIME NOT NULL
);

CREATE TABLE academia_tipo_atividade (
                                         id_academia INT NOT NULL,
                                         tipo_atividade VARCHAR(50) NOT NULL,
                                         CONSTRAINT fk_academia_tipo_atividade
                                             FOREIGN KEY (id_academia) REFERENCES academia(id_academia)
                                                 ON DELETE CASCADE
);;

-- 4. Tabela: cad_unico
CREATE TABLE IF NOT EXISTS cad_unico (
    id_cadunico INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nis VARCHAR(20) NOT NULL,
    renda_familiar DECIMAL(10, 2),
    situacao VARCHAR(100),
    data_validacao DATE,
    CONSTRAINT pk_cad_unico PRIMARY KEY (id_cadunico),
    CONSTRAINT uq_cad_unico_nis UNIQUE (nis),
    CONSTRAINT fk_cad_unico_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabela: validacao_cad_unico
CREATE TABLE IF NOT EXISTS validacao_cad_unico (
    id_validacao INT AUTO_INCREMENT,
    id_cadunico INT NOT NULL,
    data_consulta DATETIME DEFAULT CURRENT_TIMESTAMP,
    resultado VARCHAR(255),
    mensagem VARCHAR(255),
    orgao_responsavel VARCHAR(100),
    CONSTRAINT pk_validacao_cad_unico PRIMARY KEY (id_validacao),
    CONSTRAINT fk_validacao_cad_unico_cad
        FOREIGN KEY (id_cadunico) REFERENCES cad_unico (id_cadunico)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Tabela: atividade
CREATE TABLE IF NOT EXISTS atividade (
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
        FOREIGN KEY (id_academia) REFERENCES academia (id_academia)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Tabela: agendamento
CREATE TABLE IF NOT EXISTS agendamento (
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
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_agendamento_atividade
        FOREIGN KEY (id_atividade) REFERENCES atividade (id_atividade)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_agendamento_academia
        FOREIGN KEY (id_academia) REFERENCES academia (id_academia)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Tabela: checkin
CREATE TABLE IF NOT EXISTS checkin (
    id_checkin INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_academia INT NOT NULL,
    id_agendamento INT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    qr_code TEXT,
    status VARCHAR(50),
    CONSTRAINT pk_checkin PRIMARY KEY (id_checkin),
    CONSTRAINT fk_checkin_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_checkin_academia
        FOREIGN KEY (id_academia) REFERENCES academia (id_academia)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_checkin_agendamento
        FOREIGN KEY (id_agendamento) REFERENCES agendamento (id_agendamento)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Índices Otimizadores
-- -----------------------------------------------------
CREATE INDEX idx_checkin_data ON checkin (data_hora);
