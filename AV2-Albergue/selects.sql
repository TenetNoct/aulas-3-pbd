/*
 * ===================================================================================
 * SCRIPT DE CONSULTA DE DADOS (SELECT)
 * PROJETO: Sistema de Reservas para Albergue (XPTOTec)
 * OBJETIVO: Fornecer exemplos de consultas para listagem geral e detalhamento
 * de registros únicos, respeitando as regras de negócio e a performance.
 * ===================================================================================
*/

USE albergue_xpto;

-- =================================================================================
-- PARTE 1: CONSULTAS DE LISTAGEM GERAL (TODOS OS REGISTROS)
-- Usadas para painéis administrativos, relatórios e telas de listagem.
-- =================================================================================

-- 1.1: Listar todos os usuários ativos (informações básicas)
SELECT
    id_usuario,
    nome,
    email,
    data_cadastro
FROM
    USUARIOS
ORDER BY
    nome;

-- 1.2: Listar todos os quartos com a contagem de vagas em cada um
SELECT
    q.id_quarto,
    q.nome_quarto,
    q.possui_banheiro,
    q.ativo,
    COUNT(v.id_vaga) AS total_vagas
FROM
    QUARTOS q
LEFT JOIN -- Usar LEFT JOIN para incluir quartos mesmo que não tenham vagas cadastradas
    VAGAS v ON q.id_quarto = v.id_quarto
GROUP BY
    q.id_quarto
ORDER BY
    q.nome_quarto;

-- 1.3: Listar todas as reservas confirmadas, com o nome do cliente
SELECT
    r.id_reserva,
    r.data_inicio,
    r.data_fim,
    u.nome AS nome_cliente,
    r.valor_total,
    r.status_reserva
FROM
    RESERVAS r
JOIN
    USUARIOS u ON r.id_usuario = u.id_usuario
WHERE
    r.status_reserva = 'Confirmada'
ORDER BY
    r.data_inicio DESC;


-- =================================================================================
-- PARTE 2: CONSULTAS DE DETALHAMENTO (REGISTRO ÚNICO)
-- Usadas quando o usuário clica em um item para ver seus detalhes.
-- =================================================================================

-- 2.1: Detalhar uma reserva específica, mostrando todos os seus dados e as vagas inclusas.
SET @id_reserva_alvo = 1; -- Variável para definir qual reserva detalhar

-- Query Principal: Pega os dados gerais da reserva e do cliente.
SELECT
    r.id_reserva,
    r.status_reserva,
    r.tipo_reserva,
    r.data_inicio,
    r.data_fim,
    r.valor_total,
    u.nome AS nome_cliente,
    u.email AS email_cliente
FROM
    RESERVAS r
JOIN
    USUARIOS u ON r.id_usuario = u.id_usuario
WHERE
    r.id_reserva = @id_reserva_alvo;

-- Query Secundária: Lista as vagas específicas contidas na reserva.
SELECT
    v.identificador_vaga,
    q.nome_quarto,
    rv.preco_diaria_registrado
FROM
    RESERVA_VAGAS rv
JOIN
    VAGAS v ON rv.id_vaga = v.id_vaga
JOIN
    QUARTOS q ON v.id_quarto = q.id_quarto
WHERE
    rv.id_reserva = @id_reserva_alvo;

-- 2.2: Detalhar uma vaga específica, mostrando suas características.
SET @id_vaga_alvo = 1; -- Variável para definir qual vaga detalhar

SELECT
    v.id_vaga,
    v.identificador_vaga,
    v.preco_padrao,
    v.ativa,
    q.nome_quarto,
    q.possui_banheiro,
    -- GROUP_CONCAT é uma função poderosa para agregar strings de múltiplas linhas
    GROUP_CONCAT(c.nome SEPARATOR ', ') AS caracteristicas
FROM
    VAGAS v
JOIN
    QUARTOS q ON v.id_quarto = q.id_quarto
LEFT JOIN
    VAGA_CARACTERISTICAS vc ON v.id_vaga = vc.id_vaga
LEFT JOIN
    CARACTERISTICAS c ON vc.id_caracteristica = c.id_caracteristica
WHERE
    v.id_vaga = @id_vaga_alvo
GROUP BY
    v.id_vaga;

