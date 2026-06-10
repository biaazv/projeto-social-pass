-- COMANDO PARA EXECUTAR NO TERMINAL:
-- troque o root pelo seu usuario
-- mysql -u root -p < popula_banco.sql
START TRANSACTION;

-- 1. DESATIVAR CHECAGEM DE CHAVES ESTRANGEIRAS
SET FOREIGN_KEY_CHECKS = 0;

-- 2. LIMPAR TABELAS E REINICIAR OS CONTADORES
TRUNCATE TABLE gympass_db.checkin;
TRUNCATE TABLE gympass_db.agendamento;
TRUNCATE TABLE gympass_db.atividade;
TRUNCATE TABLE gympass_db.validacao_cad_unico;
TRUNCATE TABLE gympass_db.cad_unico;
TRUNCATE TABLE gympass_db.academia;
TRUNCATE TABLE gympass_db.dependente;
TRUNCATE TABLE gympass_db.usuario;

-- 3. REATIVAR CHECAGEM DE CHAVES ESTRANGEIRAS
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 4. INÍCIO DOS INSERTS
-- ==========================================

INSERT INTO gympass_db.usuario (nome_completo, nome_usuario, email, senha, cpf, data_nascimento, telefone, status_conta) VALUES
('Ana Silva Santos', 'ana.silva', 'ana@email.com', 'Senha123', '123.456.789-01', '1985-03-12', '(21) 98888-7777', 'ATIVO'),
('Bruno Oliveira Souza', 'bruno.oliveira', 'bruno@email.com', 'Senha123', '234.567.890-12', '1990-07-22', '(21) 98888-6666', 'ATIVO'),
('Carlos Eduardo Lima', 'carlos.lima', 'carlos@email.com', 'Senha123', '345.678.901-23', '1978-11-05', '(21) 98888-5555', 'INATIVO'),
('Daniela Martins Costa', 'daniela.costa', 'daniela@email.com', 'Senha123', '456.789.012-34', '1995-05-18', '(21) 98888-4444', 'ATIVO'),
('Eduardo Alves Ribeiro', 'eduardo.ribeiro', 'eduardo@email.com', 'Senha123', '567.890.123-45', '1982-09-30', '(21) 98888-3333', 'PENDENTE_VERIFICACAO');

INSERT INTO gympass_db.dependente (id_usuario, nome, cpf, data_nascimento, parentesco, status) VALUES
(1, 'Pedro Silva Santos', '987.654.321-09', '2015-05-20', 'Filho(a)', 'ATIVO'),
(1, 'Lucas Silva Santos', '876.543.210-98', '2018-08-14', 'Filho(a)', 'ATIVO'),
(2, 'Beatriz Oliveira Souza', '765.432.109-87', '2012-11-02', 'Filho(a)', 'ATIVO');

INSERT INTO gympass_db.academia (nome, endereco, bairro, latitude, longitude, telefone, status) VALUES
('Espaço Saúde & Movimento', 'Rua Voluntários da Pátria, 450', 'Botafogo', -22.9548, -43.1932, '(21) 2539-5678', 'Ativo'),
('Smart Forma', 'Avenida Atlântica, 1500', 'Copacabana', -22.9698, -43.1794, '(21) 2255-4321', 'Ativo'),
('Academia AquaVida', 'Rua das Laranjeiras, 300', 'Laranjeiras', -22.9329, -43.1876, '(21) 2557-9876', 'Ativo');

INSERT INTO gympass_db.cad_unico (id_usuario, nis, renda_familiar, situacao, data_validacao) VALUES
(1, '12345678901', 1412.00, 'Regular', '2026-01-15'),
(2, '23456789012', 600.50, 'Regular', '2026-02-10');

INSERT INTO gympass_db.validacao_cad_unico (id_cadunico, resultado, mensagem, orgao_responsavel) VALUES
(1, 'Aprovado', 'Perfil socioeconômico validado com sucesso.', 'MDS / Cadastro Único'),
(2, 'Aprovado', 'Benefício social ativo verificado.', 'MDS / Cadastro Único');

INSERT INTO gympass_db.atividade (id_academia, nome, descricao, categoria, duracao_minutos, capacidade_maxima, status) VALUES
(1, 'Musculação Livre', 'Acesso à área de pesos livres e aparelhos.', 'Musculação', 90, 50, 'Ativo'),
(1, 'Spinning', 'Aula de ciclismo indoor de alta intensidade.', 'Cardio', 45, 20, 'Ativo');

INSERT INTO gympass_db.agendamento (id_usuario, id_atividade, id_academia, data_agendamento, horario, status) VALUES
(1, 1, 1, '2026-05-25', '07:00:00', 'Confirmado');

INSERT INTO gympass_db.checkin (id_usuario, id_academia, id_agendamento, status) VALUES
(1, 1, 1, 'Realizado');

COMMIT;
