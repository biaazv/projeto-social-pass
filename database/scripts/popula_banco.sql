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

-- Senha 'Senha123' hasheada com BCrypt (custo 10): $2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O

INSERT INTO gympass_db.usuario (nome_completo, nome_usuario, email, senha, cpf, data_nascimento, telefone, status_conta) VALUES
('Ana Silva Santos', 'ana.silva', 'ana@email.com', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', '123.456.789-01', '1985-03-12', '(21) 98888-7777', 'ATIVO'),
('Bruno Oliveira Souza', 'bruno.oliveira', 'bruno@email.com', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', '234.567.890-12', '1990-07-22', '(21) 98888-6666', 'ATIVO'),
('Carlos Eduardo Lima', 'carlos.lima', 'carlos@email.com', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', '345.678.901-23', '1978-11-05', '(21) 98888-5555', 'INATIVO'),
('Daniela Martins Costa', 'daniela.costa', 'daniela@email.com', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', '456.789.012-34', '1995-05-18', '(21) 98888-4444', 'ATIVO'),
('Eduardo Alves Ribeiro', 'eduardo.ribeiro', 'eduardo@email.com', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', '567.890.123-45', '1982-09-30', '(21) 98888-3333', 'PENDENTE_VERIFICACAO');

INSERT INTO gympass_db.dependente (id_usuario, nome, cpf, data_nascimento, parentesco, status) VALUES
(1, 'Pedro Silva Santos', '987.654.321-09', '2015-05-20', 'Filho(a)', 'ATIVO'),
(1, 'Lucas Silva Santos', '876.543.210-98', '2018-08-14', 'Filho(a)', 'ATIVO'),
(2, 'Beatriz Oliveira Souza', '765.432.109-87', '2012-11-02', 'Filho(a)', 'ATIVO');

INSERT INTO gympass_db.academia (nome, endereco, bairro, cnpj, telefone, email, dias_funcionamento, horario_abertura, horario_fechamento, horario_funcionamento, possui_vestiario, status, senha, data_cadastro, data_atualizacao) VALUES
('Espaço Saúde & Movimento', 'Rua Voluntários da Pátria, 450', 'Botafogo', '12345678000101', '(21) 2539-5678', 'contato@saudemovimento.com', 'SEGUNDA_A_SABADO', '06:00:00', '22:00:00', 'SEGUNDA_A_SABADO 06:00-22:00', 1, 'ATIVA', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', NOW(), NOW()),
('Smart Forma', 'Avenida Atlântica, 1500', 'Copacabana', '12345678000102', '(21) 2255-4321', 'copacabana@smartforma.com', 'TODOS_OS_DIAS', '05:00:00', '23:00:00', 'TODOS_OS_DIAS 05:00-23:00', 1, 'ATIVA', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', NOW(), NOW()),
('Academia AquaVida', 'Rua das Laranjeiras, 300', 'Laranjeiras', '12345678000103', '(21) 2557-9876', 'aqua@vidagym.com', 'SEGUNDA_A_SEXTA', '07:00:00', '21:00:00', 'SEGUNDA_A_SEXTA 07:00-21:00', 0, 'ATIVA', '$2a$10$8.V9TrTYz9wJJufBv.jY9eN7hC8Wz.w6iO6zKzZk8.z3F9h8e6e2O', NOW(), NOW());

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
