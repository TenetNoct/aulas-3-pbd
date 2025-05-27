--
-- Banco de dados: `salaodomarcos`
--

--
-- Despejando dados para a tabela `agendamentos`
--

INSERT INTO `agendamentos` (`agendamento_id`, `cliente_id`, `servico_id`, `profissional_id`, `data_hora_inicio`, `data_hora_fim`, `status_agendamento`, `valor_cobrado`, `data_criacao`, `observacoes`) VALUES
(1, 1, 206, 101, '2025-06-10 10:00:00', '2025-06-10 11:15:00', 'Confirmado', 120.00, '2025-05-20 14:00:00', 'Maquiagem para casamento, foco nos olhos.'),
(2, 2, 209, 103, '2025-06-11 14:00:00', '2025-06-11 14:45:00', 'Agendado', 50.00, '2025-05-21 10:30:00', 'Corte degradê, máquina 2 nas laterais.'),
(3, 3, 211, 104, '2025-06-12 16:00:00', '2025-06-12 17:00:00', 'Confirmado', 150.00, '2025-05-22 09:00:00', 'Preferência por óleos essenciais de lavanda.'),
(4, 1, 208, 101, '2025-05-15 13:00:00', '2025-05-15 15:00:00', 'Concluído', 180.00, '2025-05-10 11:00:00', 'Cliente satisfeita.'),
(5, 2, 213, 105, '2025-06-14 10:30:00', '2025-06-14 11:15:00', 'Agendado', 40.00, '2025-05-25 17:00:00', NULL),
(6, 3, 212, 104, '2025-06-18 11:00:00', '2025-06-18 12:30:00', 'Confirmado', 110.00, '2025-05-26 18:00:00', 'Pele oleosa, foco em extração.'),
(8, 2, 210, 103, '2025-05-20 17:00:00', '2025-05-20 17:30:00', 'Não Compareceu', 35.00, '2025-05-15 12:00:00', 'Tentativa de contato sem sucesso.');

--
-- Despejando dados para a tabela `centros_servico`
--

INSERT INTO `centros_servico` (`centro_id`, `nome`, `descricao`) VALUES
(1, 'Salão Beleza Divina', 'Um espaço completo para cuidados capilares, unhas e estética.'),
(2, 'Barbearia Clássica do Roberto', 'Barbearia tradicional especializada em cortes masculinos e barba.'),
(3, 'Spa Urbano Renovare', 'Um oásis de tranquilidade com serviços de massagem e relaxamento.');

--
-- Despejando dados para a tabela `clientes`
--

INSERT INTO `clientes` (`cliente_id`, `nome_completo`, `email`, `telefone`, `senha_hash`, `data_cadastro`, `saldo_credito`) VALUES
(1, 'Ana Silva', 'ana.silva@example.com', '5511987654321', 'hash_da_senha_123', '2023-01-15 10:00:00', 150.75),
(2, 'Bruno Costa', 'bruno.costa@example.com', '5521998765432', 'hash_da_senha_456', '2023-02-20 14:30:00', 200.00),
(3, 'Carla Souza', 'carla.souza@example.com', '5531976543210', 'hash_da_senha_789', '2023-03-05 09:15:00', 50.25);

--
-- Despejando dados para a tabela `especialidades_profissional`
--

INSERT INTO `especialidades_profissional` (`profissional_id`, `servico_id`) VALUES
(101, 206),
(101, 207),
(101, 208),
(102, 206),
(102, 208),
(103, 209),
(103, 210),
(104, 211),
(104, 212),
(105, 213),
(105, 214);

--
-- Despejando dados para a tabela `fila_espera`
--

INSERT INTO `fila_espera` (`fila_espera_id`, `cliente_id`, `servico_desejado_id`, `profissional_desejado_id`, `data_hora_chegada`, `status_fila`) VALUES
(1, 1, 206, 101, '2025-05-27 10:00:00', 'Aguardando'),
(2, 3, 211, NULL, '2025-05-27 10:15:00', 'Aguardando'),
(3, 2, 209, 103, '2025-05-27 10:30:00', 'Chamado'),
(4, 1, 213, 105, '2025-05-27 11:00:00', 'Aguardando');

--
-- Despejando dados para a tabela `horarios_trabalho_profissional`
--

INSERT INTO `horarios_trabalho_profissional` (`horario_trab_id`, `profissional_id`, `dia_semana`, `hora_inicio`, `hora_fim`) VALUES
(1, 101, 2, '09:00:00', '18:00:00'),
(2, 101, 3, '09:00:00', '18:00:00'),
(3, 101, 4, '09:00:00', '18:00:00'),
(4, 101, 5, '09:00:00', '20:00:00'),
(5, 101, 6, '10:00:00', '20:00:00'),
(6, 101, 7, '08:00:00', '16:00:00'),
(7, 102, 3, '10:00:00', '19:00:00'),
(8, 102, 4, '10:00:00', '19:00:00'),
(9, 102, 5, '10:00:00', '19:00:00'),
(10, 102, 6, '09:00:00', '17:00:00'),
(11, 103, 2, '10:00:00', '19:00:00'),
(12, 103, 3, '10:00:00', '19:00:00'),
(13, 103, 4, '10:00:00', '20:00:00'),
(14, 103, 5, '10:00:00', '20:00:00'),
(15, 103, 6, '09:00:00', '18:00:00'),
(16, 103, 7, '09:00:00', '15:00:00'),
(17, 104, 2, '13:00:00', '20:00:00'),
(18, 104, 3, '13:00:00', '20:00:00'),
(19, 104, 5, '10:00:00', '18:00:00'),
(20, 104, 6, '10:00:00', '18:00:00'),
(21, 105, 4, '09:00:00', '17:00:00'),
(22, 105, 5, '09:00:00', '17:00:00'),
(23, 105, 6, '09:00:00', '19:00:00'),
(24, 105, 7, '09:00:00', '16:00:00');

--
-- Despejando dados para a tabela `pacotes_servico`
--

INSERT INTO `pacotes_servico` (`pacote_id`, `nome`, `descricao`, `preco_pacote`, `ativo`) VALUES
(1, 'Dia da Beleza Capilar Essencial', 'Inclui Tratamento de Hidratação Capilar e Maquiagem Profissional Leve.', 200.00, 'S'),
(2, 'Combo Barbeiro Clássico', 'Corte Masculino Clássico e Design de Sobrancelhas Masculino.', 75.00, 'S'),
(3, 'Relaxamento Profundo Spa', 'Massagem Relaxante (60 min) e Limpeza de Pele Facial Profunda.', 240.00, 'S'),
(4, 'Transformação Divina Completa', 'Maquiagem Profissional, Hidratação Capilar e Depilação Completa.', 350.00, 'S'),
(5, 'Unhas Perfeitas Salão', 'Manicure Tradicional e Pedicure Tradicional.', 80.00, 'S');

--
-- Despejando dados para a tabela `pagamentos`
--

INSERT INTO `pagamentos` (`pagamento_id`, `agendamento_id`, `valor_pago`, `data_pagamento`, `status_pagamento`, `id_transacao_gateway`, `ultimos4_cartao`, `bandeira_cartao`) VALUES
(1, 1, 120.00, '2025-05-20 14:05:00', 'Processado', 'txn_gateway_ag1_ana', '1111', 'Visa'),
(2, 3, 150.00, '2025-05-22 09:05:00', 'Processado', 'txn_gateway_ag3_carla', '2222', 'Mastercard'),
(3, 4, 180.00, '2025-05-15 15:05:00', 'Processado', 'txn_gateway_ag4_ana_concl', '3333', 'Elo'),
(4, 6, 110.00, '2025-05-26 18:05:00', 'Processado', 'txn_gateway_ag6_carla', '4444', 'Amex'),
(6, 8, 35.00, '2025-05-20 17:35:00', 'Falha', 'txn_gateway_ag8_bruno_nc', NULL, NULL);

--
-- Despejando dados para a tabela `profissionais`
--

INSERT INTO `profissionais` (`profissional_id`, `nome_completo`, `email_corporativo`, `telefone`, `data_contratacao`, `ativo`) VALUES
(101, 'Marcia Cabeleireira', 'marcia.cabelos@salaodomarcos.com', '5521987654321', '2022-05-10', 'S'),
(102, 'Claudia Manicure', 'claudia.unhas@salaodomarcos.com', '5521998765432', '2021-09-20', 'S'),
(103, 'Roberto Barbeiro', 'roberto.barber@salaodomarcos.com', '5521976543210', '2023-01-25', 'S'),
(104, 'Fernanda Terapeuta', 'fernanda.spa@renovare.com', '5531988887777', '2023-03-01', 'S'),
(105, 'Juliana Nails', 'juliana.nails@salaodivina.com', '5511977776666', '2023-04-15', 'S');

--
-- Despejando dados para a tabela `servicos`
--

INSERT INTO `servicos` (`servico_id`, `centro_id`, `nome`, `descricao`, `duracao_minutos`, `preco`, `ativo`) VALUES
(206, 1, 'Maquiagem Profissional', 'Aplicação de maquiagem para eventos especiais.', 75, 120.00, 'S'),
(207, 1, 'Tratamento de Hidratação Capilar', 'Hidratação profunda para cabelos danificados.', 90, 90.00, 'S'),
(208, 1, 'Depilação Completa', 'Remoção de pelos corporais com cera quente/fria.', 120, 180.00, 'S'),
(209, 2, 'Corte Masculino Clássico', 'Corte de cabelo masculino com acabamento tradicional.', 45, 50.00, 'S'),
(210, 2, 'Design de Sobrancelhas Masculino', 'Modelagem de sobrancelhas para homens.', 30, 35.00, 'S'),
(211, 3, 'Massagem Relaxante', 'Massagem corporal completa para alívio do estresse.', 60, 150.00, 'S'),
(212, 3, 'Limpeza de Pele Facial', 'Limpeza profunda com extração e hidratação.', 90, 110.00, 'S'),
(213, 1, 'Manicure Tradicional', 'Cutilagem e esmaltação de unhas das mãos.', 45, 40.00, 'S'),
(214, 1, 'Pedicure Tradicional', 'Cutilagem e esmaltação de unhas dos pés.', 60, 50.00, 'S');

--
-- Despejando dados para a tabela `servicos_do_pacote`
--

INSERT INTO `servicos_do_pacote` (`pacote_id`, `servico_id`) VALUES
(1, 206),
(1, 207),
(2, 209),
(2, 210),
(3, 211),
(3, 212),
(4, 206),
(4, 207),
(4, 208),
(5, 213),
(5, 214);
COMMIT;
