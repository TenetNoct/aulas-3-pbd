USE albergue_xpto;

-- Cenário 1: Confirmação de Reserva
-- O usuário da Reserva #2 (ID 2) realizou o pagamento.
-- Precisamos atualizar o status da reserva e inserir o registro de pagamento.
START TRANSACTION;

-- Primeiro, insere o pagamento que foi aprovado
INSERT INTO PAGAMENTOS (id_reserva, id_transacao_gateway, valor, status_pagamento)
VALUES (2, 'txn_gateway_7g8h9i', 1900.00, 'Aprovado');

-- Em seguida, atualiza o status da reserva para 'Confirmada'
UPDATE RESERVAS
SET status_reserva = 'Confirmada'
WHERE id_reserva = 2;

COMMIT;
SELECT 'Cenário 1: Reserva #2 confirmada com sucesso.' as log;


-- Cenário 2: Atualização de Perfil de Usuário
-- A usuária Ana Silva (ID 1) mudou seu nome de casada e e-mail.
UPDATE USUARIOS
SET
    nome = 'Ana Silva Costa',
    email = 'ana.costa@email.com'
WHERE
    id_usuario = 1;
SELECT 'Cenário 2: Perfil da usuária #1 atualizado.' as log;


-- Cenário 3: Reajuste de Preço Padrão
-- O gerente decidiu que as vagas do "Dormitório Térreo Sombra" (Quarto 2)
-- devem ter um pequeno aumento no preço padrão.
UPDATE VAGAS
SET preco_padrao = preco_padrao * 1.05 -- Aumento de 5%
WHERE id_quarto = 2;
SELECT 'Cenário 3: Preços padrão do Quarto #2 reajustados.' as log;


-- Cenário 4: Cancelamento de Reserva pelo Usuário
-- O usuário da Reserva #4 decide cancelar. A política de cancelamento se aplica.
-- A regra de negócio (data limite para cancelamento) seria verificada pela aplicação.
-- Aqui, apenas simulamos a atualização do status.
UPDATE RESERVAS
SET status_reserva = 'Cancelada'
WHERE id_reserva = 4;
-- A aplicação também iniciaria o processo de estorno do pagamento.
UPDATE PAGAMENTOS
SET status_pagamento = 'Estornado'
WHERE id_reserva = 4 AND status_pagamento = 'Aprovado';
SELECT 'Cenário 4: Reserva #4 cancelada e pagamento estornado.' as log;


-- Cenário 5: Modificação de Descrição de Quarto
-- O quarto "Suíte Família" (ID 8) foi reformado.
UPDATE QUARTOS
SET descricao = 'Suíte recém-reformada para 4 pessoas, com SmartTV e frigobar.'
WHERE id_quarto = 8;
SELECT 'Cenário 5: Descrição do Quarto #8 atualizada.' as log;

