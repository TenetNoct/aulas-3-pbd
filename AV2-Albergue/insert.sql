-- Seleciona o banco de dados para uso
USE albergue_xpto;

-- Desativa temporariamente a verificação de chaves estrangeiras para inserção em massa.
-- Isso é uma prática comum para acelerar grandes cargas de dados.
SET FOREIGN_KEY_CHECKS=0;

-- Limpa as tabelas na ordem correta para evitar erros de FK em re-execuções
TRUNCATE TABLE INDISPONIBILIDADES;
TRUNCATE TABLE TARIFAS;
TRUNCATE TABLE AVALIACOES;
TRUNCATE TABLE PAGAMENTOS;
TRUNCATE TABLE RESERVA_VAGAS;
TRUNCATE TABLE RESERVAS;
TRUNCATE TABLE VAGA_CARACTERISTICAS;
TRUNCATE TABLE CARACTERISTICAS;
TRUNCATE TABLE TIPOS_CARACTERISTICA;
TRUNCATE TABLE VAGAS;
TRUNCATE TABLE QUARTOS;
TRUNCATE TABLE USUARIOS;

-- Etapa 1: Inserção de Dados Mestres e de Configuração
-- --------------------------------------------------------

-- Inserindo 50 usuários de exemplo
INSERT INTO `USUARIOS` (`id_usuario`, `nome`, `email`, `senha_hash`) VALUES
(1, 'Ana Silva', 'ana.silva@email.com', '$2y$10$Y.iW.e.gN9zP3.sU/L.h.O8y3j.e.qD/R.sT.uV/W.xY.z'),
(2, 'Bruno Costa', 'bruno.costa@email.com', '$2y$10$A.bC.d.eF/G.hI.jK.lM.nO.pQ/R.sT.uV/W.xY.z'),
(3, 'Carla Dias', 'carla.dias@email.com', '$2y$10$B.cC.d.eF/G.hI.jK.lM.nO.pQ/R.sT.uV/W.xY.z'),
-- Adicionando mais usuários para volume
(4, 'Daniel Martins', 'daniel.martins@email.com', '$2y$10$C.dE.f.gH/I.jK.lM.nO.pQ/R.sT.uV/W.xY.z'),
(5, 'Eduarda Lima', 'eduarda.lima@email.com', '$2y$10$D.eF.g.hI/J.kL.mN.oP.qR/S.tU.vW/X.yZ.a'),
(6, 'Fábio Pereira', 'fabio.pereira@email.com', '$2y$10$E.fG.h.iJ/K.lM.nO.pQ.rS/T.uV.wX/Y.zZ.b'),
(7, 'Gabriela Alves', 'gabriela.alves@email.com', '$2y$10$F.gH.i.jK/L.mN.oP.qR.sT/U.vW.xY/Z.aA.c'),
(8, 'Heitor Santos', 'heitor.santos@email.com', '$2y$10$G.hI.j.kL/M.nO.pQ.rS.tU/V.wX.yZ/A.bB.d'),
(9, 'Isabela Rocha', 'isabela.rocha@email.com', '$2y$10$H.iJ.k.lM/N.oP.qR.sT.uV/W.xY.zZ/B.cC.e'),
(10, 'João Mendes', 'joao.mendes@email.com', '$2y$10$I.jK.l.mN/O.pQ.rS.tU.vW/X.yZ.aA/C.dD.f');
-- ... Repita o padrão para chegar a 50 usuários ...
INSERT INTO USUARIOS (nome, email, senha_hash) SELECT CONCAT('Usuário Teste ', id), CONCAT('teste', id, '@email.com'), '$2y$10$...' FROM (SELECT (a.a + (10 * b.a) + (100 * c.a)) as id FROM (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as a, (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as b, (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as c) as ids WHERE id BETWEEN 11 AND 50;


-- Inserindo 10 quartos com diferentes configurações
INSERT INTO `QUARTOS` (`id_quarto`, `nome_quarto`, `descricao`, `possui_banheiro`) VALUES
(1, 'Dormitório Térreo Sol', 'Quarto coletivo com 8 vagas, bem iluminado pela manhã.', false),
(2, 'Dormitório Térreo Sombra', 'Quarto coletivo com 8 vagas, mais reservado e fresco.', false),
(3, 'Suíte Coletiva Aqua', 'Suíte para 4 pessoas com banheiro privativo.', true),
(4, 'Suíte Coletiva Terra', 'Suíte para 4 pessoas com banheiro privativo e vista para o jardim.', true),
(5, 'Dormitório Amplo 12', 'Grande dormitório com 12 vagas e banheiro compartilhado interno.', true),
(6, 'Dormitório Superior A', 'Quarto coletivo com 8 vagas no andar de cima.', false),
(7, 'Dormitório Superior B', 'Quarto coletivo com 8 vagas no andar de cima.', false),
(8, 'Suíte Família', 'Suíte para 4 pessoas, ideal para famílias ou pequenos grupos.', true),
(9, 'Dormitório Econômico', 'Dormitório com 12 vagas, o mais acessível.', true),
(10, 'Suíte Luxo', 'Suíte privativa para 4 pessoas com ar condicionado e sacada.', true);

-- Inserindo vagas para cada quarto (Total: 80 vagas)
-- Quarto 1 (8 vagas)
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) VALUES
(1, '1A', 75.00), (1, '1B', 75.00), (1, '1C', 70.00), (1, '1D', 70.00), (1, '1E', 75.00), (1, '1F', 75.00), (1, '1G', 70.00), (1, '1H', 70.00);
-- Quarto 2 (8 vagas)
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) VALUES
(2, '2A', 75.00), (2, '2B', 75.00), (2, '2C', 70.00), (2, '2D', 70.00), (2, '2E', 75.00), (2, '2F', 75.00), (2, '2G', 70.00), (2, '2H', 70.00);
-- Quarto 3 (4 vagas)
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) VALUES
(3, '3A', 95.00), (3, '3B', 95.00), (3, '3C', 90.00), (3, '3D', 90.00);
-- Quarto 4 (4 vagas)
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) VALUES
(4, '4A', 100.00), (4, '4B', 100.00), (4, '4C', 95.00), (4, '4D', 95.00);
-- Quarto 5 (12 vagas)
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) VALUES
(5, '5A', 65.00), (5, '5B', 65.00), (5, '5C', 60.00), (5, '5D', 60.00), (5, '5E', 65.00), (5, '5F', 65.00), (5, '5G', 60.00), (5, '5H', 60.00), (5, '5I', 65.00), (5, '5J', 65.00), (5, '5K', 60.00), (5, '5L', 60.00);
-- ... Inserir vagas para os quartos 6 a 10 seguindo o padrão ...
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) SELECT 6, CONCAT('6', CHAR(65+id-1)), 72.00 FROM (SELECT (a.a + (10 * b.a)) as id FROM (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7) as a, (select 0 as a) as b) as ids WHERE id > 0;
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) SELECT 7, CONCAT('7', CHAR(65+id-1)), 72.00 FROM (SELECT (a.a + (10 * b.a)) as id FROM (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7) as a, (select 0 as a) as b) as ids WHERE id > 0;
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) SELECT 8, CONCAT('8', CHAR(65+id-1)), 110.00 FROM (SELECT (a.a + (10 * b.a)) as id FROM (select 0 as a union all select 1 union all select 2 union all select 3) as a, (select 0 as a) as b) as ids WHERE id > 0;
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) SELECT 9, CONCAT('9', CHAR(65+id-1)), 58.00 FROM (SELECT (a.a + (10 * b.a)) as id FROM (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9 union all select 10 union all select 11) as a, (select 0 as a) as b) as ids WHERE id > 0;
INSERT INTO VAGAS (id_quarto, identificador_vaga, preco_padrao) SELECT 10, CONCAT('10', CHAR(65+id-1)), 150.00 FROM (SELECT (a.a + (10 * b.a)) as id FROM (select 0 as a union all select 1 union all select 2 union all select 3) as a, (select 0 as a) as b) as ids WHERE id > 0;

-- Inserindo tipos de características
INSERT INTO `TIPOS_CARACTERISTICA` (`id_tipo_caracteristica`, `nome`) VALUES
(1, 'Posição no Quarto'), (2, 'Tipo de Cama'), (3, 'Exposição Solar');

-- Inserindo características
INSERT INTO `CARACTERISTICAS` (`id_caracteristica`, `id_tipo_caracteristica`, `nome`) VALUES
(1, 1, 'Perto da Janela'), (2, 1, 'Perto da Porta'), (3, 2, 'Beliche - Cima'), (4, 2, 'Beliche - Baixo'), (5, 3, 'Sol da Manhã'), (6, 3, 'Sem Sol Direto'), (7, 2, 'Cama de Solteiro');

-- Associando características a algumas vagas
INSERT INTO VAGA_CARACTERISTICAS (id_vaga, id_caracteristica) VALUES (1,1), (5,1);
INSERT INTO VAGA_CARACTERISTICAS (id_vaga, id_caracteristica) VALUES (1,3),(2,4),(3,3),(4,4),(5,3),(6,4),(7,3),(8,4);
INSERT INTO VAGA_CARACTERISTICAS (id_vaga, id_caracteristica) VALUES (1,5),(2,5),(3,5),(4,5),(5,5),(6,5),(7,5),(8,5);


-- Etapa 2: Inserção de Dados Transacionais
-- --------------------------------------------------------

-- Reserva #1: Confirmada, no passado, com avaliação
INSERT INTO RESERVAS (id_reserva, id_usuario, data_inicio, data_fim, valor_total, status_reserva, tipo_reserva) VALUES (1, 1, '2025-04-10', '2025-04-15', 375.00, 'Concluída', 'VAGA_AVULSA');
INSERT INTO RESERVA_VAGAS (id_reserva, id_vaga, preco_diaria_registrado) VALUES (1, 1, 75.00);
INSERT INTO PAGAMENTOS (id_reserva, id_transacao_gateway, valor, status_pagamento) VALUES (1, 'txn_gateway_1a2b3c', 375.00, 'Aprovado');
INSERT INTO AVALIACOES (id_reserva, nota_geral, comentario) VALUES (1, 5, 'Excelente estadia! O quarto era limpo e a vaga perto da janela fez toda a diferença.');

-- Reserva #2: Aluguel de quarto inteiro, futuro, pendente de pagamento
INSERT INTO RESERVAS (id_reserva, id_usuario, data_inicio, data_fim, valor_total, status_reserva, tipo_reserva) VALUES (2, 2, '2025-07-20', '2025-07-25', 1900.00, 'Pendente', 'QUARTO_INTEIRO');
INSERT INTO RESERVA_VAGAS (id_reserva, id_vaga, preco_diaria_registrado) VALUES (2, 9, 95.00), (2, 10, 95.00), (2, 11, 95.00), (2, 12, 95.00);

-- Reserva #3: Cancelada
INSERT INTO RESERVAS (id_reserva, id_usuario, data_inicio, data_fim, valor_total, status_reserva, tipo_reserva) VALUES (3, 3, '2025-08-01', '2025-08-05', 400.00, 'Cancelada', 'VAGA_AVULSA');
INSERT INTO RESERVA_VAGAS (id_reserva, id_vaga, preco_diaria_registrado) VALUES (3, 13, 100.00);

-- Reserva #4: Ativa no momento (hoje é 2025-06-19)
INSERT INTO RESERVAS (id_reserva, id_usuario, data_inicio, data_fim, valor_total, status_reserva, tipo_reserva) VALUES (4, 4, '2025-06-18', '2025-06-22', 300.00, 'Confirmada', 'VAGA_AVULSA');
INSERT INTO RESERVA_VAGAS (id_reserva, id_vaga, preco_diaria_registrado) VALUES (4, 2, 75.00);
INSERT INTO PAGAMENTOS (id_reserva, id_transacao_gateway, valor, status_pagamento) VALUES (4, 'txn_gateway_4d5e6f', 300.00, 'Aprovado');

-- Etapa 3: Inserção de Dados de Gestão
-- --------------------------------------------------------

-- Inserindo tarifas especiais (Alta temporada no verão)
INSERT INTO TARIFAS (id_quarto, data_inicio, data_fim, preco_diaria) VALUES
(10, '2025-12-20', '2026-01-10', 190.00); -- Suíte Luxo mais cara no Reveillon
INSERT INTO TARIFAS (id_vaga, data_inicio, data_fim, preco_diaria) VALUES
(13, '2025-07-01', '2025-07-31', 115.00); -- Vaga específica mais cara nas férias de Julho

-- Inserindo bloqueios/indisponibilidades
-- Bloqueio para manutenção de uma vaga
INSERT INTO INDISPONIBILIDADES (id_vaga, data_inicio, data_fim, motivo) VALUES
(20, '2025-09-01 08:00:00', '2025-09-02 18:00:00', 'Troca de colchão');
-- Bloqueio para dedetização de um quarto inteiro
INSERT INTO INDISPONIBILIDADES (id_quarto, data_inicio, data_fim, motivo) VALUES
(2, '2025-10-10 12:00:00', '2025-10-11 12:00:00', 'Dedetização anual');


-- Reativa a verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS=1;

SELECT 'Script de inserção massiva concluído com sucesso.' AS status;
