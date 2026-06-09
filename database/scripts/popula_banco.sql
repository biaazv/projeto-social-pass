-- COMANDO PARA EXECUTAR NO TERMINAL:
-- troque o root pelo seu usuario
-- mysql -u root -p < popula_banco.sql
START TRANSACTION;

-- 1. DESATIVAR CHECAGEM DE CHAVES ESTRANGEIRAS (Evita erros de ordem de deleção)
SET FOREIGN_KEY_CHECKS = 0;

-- 2. LIMPAR TABELAS E REINICIAR OS CONTADORES (AUTO_INCREMENT)
-- Nota: Como você está usando a sintaxe MySQL (ENGINE=InnoDB), usamos TRUNCATE.
TRUNCATE TABLE socialpass_v2_db.Checkin;
TRUNCATE TABLE socialpass_v2_db. Agendamento;
TRUNCATE TABLE socialpass_v2_db. Atividade;
TRUNCATE TABLE socialpass_v2_db. Validacao_Cad_Unico;
TRUNCATE TABLE socialpass_v2_db. Cad_Unico;
TRUNCATE TABLE socialpass_v2_db. Academia;
TRUNCATE TABLE socialpass_v2_db. Dependente;
TRUNCATE TABLE socialpass_v2_db. Usuario;

-- 3. REATIVAR CHECAGEM DE CHAVES ESTRANGEIRAS
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 4. INÍCIO DOS INSERTS (Ordem estrita de dependência)
-- ==========================================

INSERT INTO socialpass_v2_db.Usuario (nome, cpf, data_nascimento, endereco, bairro, status) VALUES
('Ana Silva Santos', '123.456.789-01', '1985-03-12', 'Rua das Flores, 123', 'Centro', 'Ativo'),
('Bruno Oliveira Souza', '234.567.890-12', '1990-07-22', 'Avenida Central, 456', 'Copacabana', 'Ativo'),
('Carlos Eduardo Lima', '345.678.901-23', '1978-11-05', 'Rua Voluntários da Pátria, 789', 'Botafogo', 'Inativo'),
('Daniela Martins Costa', '456.789.012-34', '1995-05-18', 'Rua Sete de Setembro, 101', 'Centro', 'Ativo'),
('Eduardo Alves Ribeiro', '567.890.123-45', '1982-09-30', 'Alameda Lorena, 202', 'Jardins', 'Pendente'),
('Fernanda Pereira Lima', '678.990.123-56', '1988-12-25', 'Rua Augusta, 303', 'Consolação', 'Ativo'),
('Gabriel Rodrigues Melo', '789.012.345-67', '2000-01-15', 'Avenida Atlântica, 2020', 'Copacabana', 'Ativo'),
('Heloísa Barbosa Castro', '890.123.456-78', '1993-04-02', 'Rua das Laranjeiras, 55', 'Laranjeiras', 'Inativo'),
('Igor Fernando Vieira', '901.234.567-89', '1975-08-14', 'Rua João de Barros, 404', 'Boa Vista', 'Ativo'),
('Juliana Mendes Fonseca', '012.345.678-90', '1991-10-10', 'Avenida Agamenon Magalhães, 505', 'Espinheiro', 'Ativo'),
('Lucas Teixeira Rocha', '135.246.579-11', '1987-06-24', 'Rua Bahia, 12', 'Sion', 'Pendente'),
('Mariana Dias Azevedo', '246.357.680-22', '1994-02-28', 'Avenida Afonso Pena, 3300', 'Cruzeiro', 'Ativo'),
('Nataniel Gomes Silva', '357.468.791-33', '1969-05-09', 'Rua dos Goitacazes, 88', 'Centro', 'Ativo'),
('Olívia Antunes Prado', '468.579.902-44', '1998-07-07', 'Rua Padre Chagas, 150', 'Moinhos de Vento', 'Ativo'),
('Pedro Henrique Souza', '579.680.013-55', '1984-11-19', 'Avenida Goethe, 45', 'Rio Branco', 'Inativo');


INSERT INTO socialpass_v2_db.Dependente (id_usuario, nome, cpf, data_nascimento, parentesco, status) VALUES
(1, 'Pedro Silva Santos', '987.654.321-09', '2015-05-20', 'Filho(a)', 'Ativo'),
(1, 'Lucas Silva Santos', '876.543.210-98', '2018-08-14', 'Filho(a)', 'Ativo'),
(2, 'Beatriz Oliveira Souza', '765.432.109-87', '2012-11-02', 'Filho(a)', 'Ativo'),
(3, 'Mariana Lima Costa', '654.321.098-76', '1980-04-25', 'Cônjuge', 'Inativo'),
(4, 'Enzo Martins Costa', '543.210.987-65', '2020-01-30', 'Filho(a)', 'Ativo'),
(5, 'Letícia Alves Ribeiro', '432.109.876-54', '1985-06-12', 'Cônjuge', 'Pendente'),
(5, 'Arthur Alves Ribeiro', '321.109.876-43', '2014-09-05', 'Filho(a)', 'Ativo'),
(6, 'Matheus Pereira Lima', '210.987.654-32', '2016-03-22', 'Filho(a)', 'Ativo'),
(7, 'Larissa Rodrigues Melo', '109.876.543-21', '2003-07-19', 'Irmão(ã)', 'Ativo'),
(8, 'Laura Barbosa Castro', '098.765.432-10', '2019-12-11', 'Filho(a)', 'Inativo'),
(9, 'Camila Fernando Vieira', '987.123.456-00', '1977-02-15', 'Cônjuge', 'Ativo'),
(10, 'Rodrigo Mendes Fonseca', '876.234.567-11', '2013-10-29', 'Filho(a)', 'Ativo'),
(12, 'Gustavo Dias Azevedo', '765.345.678-22', '1990-12-01', 'Cônjuge', 'Ativo'),
(14, 'Sophia Antunes Prado', '654.456.789-33', '2022-05-04', 'Filho(a)', 'Ativo'),
(15, 'Valentina Henrique Souza', '543.567.890-44', '2017-08-27', 'Filho(a)', 'Inativo');

INSERT INTO socialpass_v2_db.Academia (nome, endereco, bairro, latitude, longitude, telefone, status) VALUES
('Espaço Saúde & Movimento', 'Rua Voluntários da Pátria, 450', 'Botafogo', -22.9548, -43.1932, '(21) 2539-5678', 'Ativo'),
('Smart Forma', 'Avenida Atlântica, 1500', 'Copacabana', -22.9698, -43.1794, '(21) 2255-4321', 'Ativo'),
('Academia AquaVida', 'Rua das Laranjeiras, 300', 'Laranjeiras', -22.9329, -43.1876, '(21) 2557-9876', 'Ativo'),
('Academia Mar Azul', 'Rua Sete de Setembro, 85', 'Centro', -22.9038, -43.1772, '(21) 2232-1100', 'Ativo'),
('Focus Boxe & Fitness', 'Avenida Central, 800', 'Copacabana', -22.9712, -43.1855, '(21) 3813-9900', 'Pendente'),
('Carioca Fitness Tijuca', 'Rua Conde de Bonfim, 344', 'Tijuca', -22.9231, -43.2352, '(21) 2568-4433', 'Ativo'),
('Studio Cross Barra', 'Avenida das Américas, 4200', 'Barra da Tijuca', -23.0007, -43.3659, '(21) 3325-8899', 'Ativo'),
('Academia Corpo e Mente', 'Rua Dias da Cruz, 215', 'Méier', -22.8973, -43.2804, '(21) 2594-1122', 'Ativo'),
('Ipanema Beach Workout', 'Rua Visconde de Pirajá, 110', 'Ipanema', -22.9842, -43.2001, '(21) 2287-6543', 'Ativo'),
('Vibe Fit Jacarepaguá', 'Estrada dos Três Rios, 800', 'Freguesia', -22.9345, -43.3412, '(21) 3415-7766', 'Inativo'),
('Gávea Fight Club', 'Praça Santos Dumont, 20', 'Gávea', -22.9741, -43.2275, '(21) 2512-0099', 'Ativo'),
('Leblon Premium Studio', 'Avenida Ataulfo de Paiva, 550', 'Leblon', -22.9829, -43.2238, '(21) 3204-5555', 'Ativo'),
('Academia Progresso de Madureira', 'Estrada do Portela, 99', 'Madureira', -22.8752, -43.3364, '(21) 2450-1234', 'Pendente'),
('Iron Gym Campo Grande', 'Rua Viúva Dantas, 60', 'Campo Grande', -22.9029, -43.5591, '(21) 3402-8877', 'Ativo'),
('Centro de Lutas Flamengo', 'Rua Marquês de Abrantes, 150', 'Flamengo', -22.9311, -43.1789, '(21) 2552-3344', 'Ativo');

-- 4. Tabela: Cad_Unico
INSERT INTO socialpass_v2_db.Cad_Unico (id_usuario, nis, renda_familiar, situacao, data_validacao) VALUES
(1, '12345678901', 1412.00, 'Regular', '2026-01-15'),
(2, '23456789012', 600.50, 'Regular', '2026-02-10'),
(4, '34567890123', 2100.00, 'Em Análise', '2026-03-01'),
(5, '45678901234', 0.00, 'Regular', '2026-01-20'),
(7, '56789012345', 850.00, 'Regular', '2026-04-12'),
(8, '67890123456', 1200.00, 'Pendente Atualização', '2025-11-05'),
(10, '78901234567', 450.00, 'Regular', '2026-05-18'),
(13, '89012345678', 1800.00, 'Regular', '2026-02-25'),
(14, '90123456789', 700.00, 'Regular', '2026-03-14'),
(15, '01234567890', 3000.00, 'Excedeu Limite', '2026-05-01');

-- 5. Tabela: Validacao_Cad_Unico
INSERT INTO socialpass_v2_db.Validacao_Cad_Unico (id_cadunico, resultado, mensagem, orgao_responsavel) VALUES
(1, 'Aprovado', 'Perfil socioeconômico validado com sucesso.', 'MDS / Cadastro Único'),
(2, 'Aprovado', 'Benefício social ativo verificado.', 'MDS / Cadastro Único'),
(3, 'Pendente', 'Aguardando cruzamento de dados com a Receita Federal.', 'Dataprev'),
(4, 'Aprovado', 'Renda zero confirmada por ausência de vínculo empregatício.', 'MDS / Cadastro Único'),
(5, 'Aprovado', 'Critérios de elegibilidade do município atendidos.', 'Prefeitura do Rio de Janeiro'),
(6, 'Aviso', 'NIS ativo, porém necessita atualização de dados cadastrais dentro de 30 dias.', 'CRAS Regional'),
(7, 'Aprovado', 'Perfil validado.', 'MDS / Cadastro Único'),
(8, 'Aprovado', 'Validação realizada via integração direta do sistema.', 'Dataprev'),
(9, 'Aprovado', 'Critérios socioeconômicos confirmados.', 'MDS / Cadastro Único'),
(10, 'Rejeitado', 'Renda familiar per capita declarada acima do limite permitido para o programa.', 'Prefeitura do Rio de Janeiro');

-- 6. Tabela: Atividade (Apenas nas academias do Rio de Janeiro geradas anteriormente: IDs de 1 a 15)
INSERT INTO socialpass_v2_db.Atividade (id_academia, nome, descricao, categoria, duracao_minutos, capacidade_maxima, status) VALUES
(1, 'Musculação Livre', 'Acesso à área de pesos livres e aparelhos.', 'Musculação', 90, 50, 'Ativo'),
(1, 'Spinning', 'Aula de ciclismo indoor de alta intensidade.', 'Cardio', 45, 20, 'Ativo'),
(2, 'Cross Training', 'Treinamento funcional de alta intensidade focado em força e condicionamento.', 'Funcional', 60, 15, 'Ativo'),
(2, 'Mat Pilates', 'Exercícios de pilates realizados no solo para fortalecimento do core.', 'Bem-estar', 50, 12, 'Ativo'),
(3, 'Natação Iniciante', 'Aulas de natação focadas na adaptação ao meio aquático.', 'Aquática', 50, 8, 'Ativo'),
(3, 'Hidroginástica', 'Exercícios aeróbicos na piscina, ideal para todas as idades.', 'Aquática', 45, 25, 'Ativo'),
(6, 'Ritmos e FitDance', 'Aula de dança com coreografias dos sucessos atuais.', 'Dança', 60, 30, 'Ativo'),
(7, 'Yoga Integral', 'Prática que une posturas físicas, respiração e meditação.', 'Bem-estar', 60, 15, 'Ativo'),
(8, 'Muay Thai Black', 'Treino de artes marciais focado em técnicas de combate e queima calórica.', 'Lutas', 75, 20, 'Ativo'),
(11, 'Boxe Funcional', 'Fundamentos do boxe integrados a circuitos de agilidade.', 'Lutas', 60, 15, 'Ativo'),
(12, 'Circuito HIIT', 'Treino intervalado de alta intensidade para perda de gordura.', 'Cardio', 30, 20, 'Ativo'),
(13, 'Alongamento', 'Sessão focada em flexibilidade e relaxamento muscular.', 'Bem-estar', 45, 25, 'Ativo'),
(14, 'Zumba Regional', 'Dança aeróbica com ritmos latinos e brasileiros.', 'Dança', 50, 35, 'Ativo'),
(15, 'Jiu-Jitsu Iniciante', 'Introdução às técnicas de solo e defesa pessoal.', 'Lutas', 90, 18, 'Ativo'),
(15, 'Funcional para Corredores', 'Fortalecimento específico para prevenção de lesões na corrida.', 'Funcional', 45, 15, 'Ativo');

-- 7. Tabela: Agendamento (Cruzando Usuários de 1 a 15 e Atividades de 1 a 15)
INSERT INTO socialpass_v2_db.Agendamento (id_usuario, id_atividade, id_academia, data_agendamento, horario, status) VALUES
(1, 1, 1, '2026-05-25', '07:00:00', 'Confirmado'),
(1, 2, 1, '2026-05-26', '08:30:00', 'Pendente'),
(2, 3, 2, '2026-05-25', '18:00:00', 'Confirmado'),
(4, 4, 2, '2026-05-25', '19:00:00', 'Confirmado'),
(5, 5, 3, '2026-05-27', '09:00:00', 'Confirmado'),
(6, 7, 7, '2026-05-25', '07:15:00', 'Cancelado'),
(7, 8, 8, '2026-05-25', '20:00:00', 'Confirmado'),
(8, 10, 11, '2026-05-26', '17:00:00', 'Confirmado'),
(9, 11, 12, '2026-05-25', '12:00:00', 'Confirmado'),
(10, 12, 13, '2026-05-28', '08:00:00', 'Pendente'),
(11, 3, 2, '2026-05-25', '18:00:00', 'Confirmado'),
(12, 13, 14, '2026-05-25', '19:30:00', 'Confirmado'),
(13, 14, 15, '2026-05-26', '07:00:00', 'Confirmado'),
(14, 1, 1, '2026-05-25', '06:30:00', 'Confirmado'),
(15, 15, 15, '2026-05-25', '16:00:00', 'Cancelado');

-- 8. Tabela: Checkin
INSERT INTO socialpass_v2_db.Checkin (id_usuario, id_academia, id_agendamento, status) VALUES
(1, 1, 1, 'Realizado'),
(2, 2, 3, 'Realizado'),
(4, 2, 4, 'Realizado'),
(7, 8, 7, 'Realizado'),
(9, 12, 9, 'Realizado'),
(11, 2, 11, 'Realizado'),
(12, 14, 12, 'Realizado'),
(14, 1, 14, 'Realizado'),
(3, 1, NULL, 'Realizado'), -- Check-in avulso na musculação sem agendamento prévio
(5, 3, 5, 'Não Compareceu'),
(13, 15, 13, 'Realizado'),
(2, 1, NULL, 'Realizado'), -- Segundo check-in do usuário 2 em outra data/academia
(8, 11, 8, 'Realizado'),
(1, 1, NULL, 'Realizado'),
(4, 7, NULL, 'Bloqueado'); -- Cadastro Único em análise gerando bloqueio no validador da catraca

COMMIT;