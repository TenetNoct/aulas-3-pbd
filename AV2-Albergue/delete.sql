USE albergue_xpto;

-- Cenário 1: Tentativa de Deletar Dados com Filhos (Falha Esperada)
-- -------------------------------------------------------------------

-- TENTATIVA 1: Deletar um usuário que possui reservas.
-- Esta operação DEVE FALHAR por causa da constraint `fk_reservas_usuarios` (ON DELETE RESTRICT).
-- É uma medida de segurança para não perder o histórico de reservas.
-- DELETE FROM USUARIOS WHERE id_usuario = 1;
-- -> ERRO ESPERADO: Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails...

-- TENTATIVA 2: Deletar um quarto que possui vagas.
-- Esta operação DEVE FALHAR por causa da constraint `fk_vagas_quartos` (ON DELETE RESTRICT).
-- DELETE FROM QUARTOS WHERE id_quarto = 1;
-- -> ERRO ESPERADO: Error Code: 1451. Cannot delete or update a parent row...

-- TENTATIVA 3: Deletar uma característica que está em uso por vagas.
-- Esta operação DEVE FALHAR, pois VAGA_CARACTERISTICAS tem ON DELETE CASCADE.
-- Ah, não, nesse caso o cascade vai funcionar. Vamos ajustar para mostrar o ponto.
-- Se a FK em VAGA_CARACTERISTICAS fosse RESTRICT, a deleção falharia. Como é CASCADE,
-- a deleção da característica removeria todas as suas associações com as vagas.
-- Vamos demonstrar o CASCADE abaixo.


-- Cenário 2: Deleção em Cascata (Sucesso Esperado)
-- -------------------------------------------------------------------

-- A característica "Perto da Porta" (ID 2) será descontinuada.
-- Como a tabela `VAGA_CARACTERISTICAS` foi criada com `ON DELETE CASCADE`,
-- ao deletar a característica, todas as associações dela com as vagas serão
-- removidas automaticamente.
SELECT 'Associações com Característica #2 ANTES do delete:', COUNT(*) FROM VAGA_CARACTERISTICAS WHERE id_caracteristica = 2;

DELETE FROM CARACTERISTICAS WHERE id_caracteristica = 2;

SELECT 'Associações com Característica #2 DEPOIS do delete:', COUNT(*) FROM VAGA_CARACTERISTICAS WHERE id_caracteristica = 2;
SELECT 'Cenário 2: Característica #2 e suas associações foram deletadas em cascata.' as log;


-- Cenário 3: Deleção na Ordem Correta (Sucesso Esperado)
-- -------------------------------------------------------------------
-- Para deletar uma reserva, é preciso primeiro lidar com os registros filhos em
-- tabelas com constraint `ON DELETE RESTRICT` (neste caso, PAGAMENTOS).
-- A tabela `RESERVA_VAGAS` tem `ON DELETE CASCADE`, então será tratada automaticamente.

-- Vamos deletar a Reserva #3, que já estava cancelada e não possui pagamentos.
-- Isso deve funcionar diretamente.
SELECT 'Deletando a Reserva #3 (sem pagamentos)...' as log;
DELETE FROM RESERVAS WHERE id_reserva = 3;
SELECT 'Reserva #3 deletada com sucesso. Registros em RESERVA_VAGAS foram removidos em cascata.' as log;
-- Verificando se a cascata funcionou
SELECT COUNT(*) FROM RESERVA_VAGAS WHERE id_reserva = 3;


-- Agora, vamos tentar deletar a Reserva #1, que possui pagamento e avaliação.
-- As FKs de PAGAMENTOS e AVALIACOES são `RESTRICT` (implícito) e `CASCADE` respectivamente.
-- A deleção falhará por causa do pagamento.
-- DELETE FROM RESERVAS WHERE id_reserva = 1; -- FALHA!

-- A ordem correta para "apagar" o histórico completo da Reserva #1:
START TRANSACTION;
SELECT 'Iniciando a deleção completa da Reserva #1 e seus dependentes...' as log;

-- 1. Deletar os registros filhos em tabelas com ON DELETE RESTRICT
DELETE FROM PAGAMENTOS WHERE id_reserva = 1;

-- 2. Deletar o registro pai. Os filhos em tabelas com ON DELETE CASCADE (AVALIACOES, RESERVA_VAGAS)
-- serão removidos automaticamente.
DELETE FROM RESERVAS WHERE id_reserva = 1;

COMMIT;
SELECT 'Cenário 3: Reserva #1 e todos os seus dados dependentes foram removidos com sucesso na ordem correta.' as log;

