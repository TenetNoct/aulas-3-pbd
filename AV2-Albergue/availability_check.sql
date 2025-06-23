/*
 * ===================================================================================
 * SCRIPT DE VERIFICAÇÃO DE DISPONIBILIDADE
 * PROJETO: Sistema de Reservas para Albergue (XPTOTec)
 * OBJETIVO: Criar uma consulta robusta que mostre as vagas disponíveis e as
 * já ocupadas para um determinado período de tempo.
 *
 * LÓGICA DE NEGÓCIO: Uma vaga está indisponível se:
 * 1. Ela faz parte de uma reserva com status 'Confirmada' ou 'Pendente' que
 * se sobrepõe ao período desejado.
 * 2. Ela (ou o quarto inteiro) está em um bloqueio de 'INDISPONIBILIDADES'
 * que se sobrepõe ao período desejado.
 * ===================================================================================
*/

USE albergue_xpto;

-- =================================================================================
-- PARÂMETROS DE ENTRADA (Simulando a busca do usuário no site)
-- =================================================================================
SET @data_inicio_desejada = '2025-07-22';
SET @data_fim_desejada = '2025-07-28';


-- =================================================================================
-- CONSULTA 1: MOSTRAR AS VAGAS DISPONÍVEIS NO PERÍODO
-- =================================================================================
SELECT
    v.id_vaga,
    v.identificador_vaga,
    q.nome_quarto,
    q.possui_banheiro,
    v.preco_padrao,
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
    v.ativa = TRUE
    AND q.ativo = TRUE
    AND v.id_vaga NOT IN (
        -- Sub-consulta para encontrar TODAS as vagas indisponíveis no período
        
        -- Parte A: Vagas em Reservas Ativas
        SELECT rv.id_vaga
        FROM RESERVA_VAGAS rv
        JOIN RESERVAS r ON rv.id_reserva = r.id_reserva
        WHERE
            r.status_reserva IN ('Confirmada', 'Pendente')
            -- A lógica de sobreposição de datas: a reserva existente
            -- começa antes do FIM do período desejado E termina
            -- depois do INÍCIO do período desejado.
            AND r.data_inicio < @data_fim_desejada
            AND r.data_fim > @data_inicio_desejada

        UNION -- O UNION combina os resultados das duas fontes de indisponibilidade

        -- Parte B: Vagas em Bloqueios de Manutenção
        SELECT i.id_vaga
        FROM INDISPONIBILIDADES i
        WHERE
            i.id_vaga IS NOT NULL
            AND i.data_inicio < @data_fim_desejada
            AND i.data_fim > @data_inicio_desejada
            
        UNION

        -- Parte C: Vagas em Quartos Inteiros Bloqueados
        SELECT v_inner.id_vaga
        FROM VAGAS v_inner
        JOIN INDISPONIBILIDADES i_inner ON v_inner.id_quarto = i_inner.id_quarto
        WHERE
            i_inner.id_quarto IS NOT NULL
            AND i_inner.data_inicio < @data_fim_desejada
            AND i_inner.data_fim > @data_inicio_desejada
    )
GROUP BY
    v.id_vaga
ORDER BY
    q.nome_quarto, v.identificador_vaga;


-- =================================================================================
-- CONSULTA 2: MOSTRAR AS VAGAS JÁ RESERVADAS/BLOQUEADAS NO PERÍODO
-- =================================================================================

SELECT
    v.identificador_vaga,
    q.nome_quarto,
    'Reserva' AS tipo_indisponibilidade,
    r.status_reserva AS motivo,
    r.data_inicio,
    r.data_fim,
    u.nome AS responsavel
FROM
    RESERVA_VAGAS rv
JOIN RESERVAS r ON rv.id_reserva = r.id_reserva
JOIN VAGAS v ON rv.id_vaga = v.id_vaga
JOIN QUARTOS q ON v.id_quarto = q.id_quarto
JOIN USUARIOS u ON r.id_usuario = u.id_usuario
WHERE
    r.status_reserva IN ('Confirmada', 'Pendente')
    AND r.data_inicio < @data_fim_desejada
    AND r.data_fim > @data_inicio_desejada

UNION

SELECT
    v.identificador_vaga,
    q.nome_quarto,
    'Bloqueio Operacional' AS tipo_indisponibilidade,
    i.motivo,
    i.data_inicio,
    i.data_fim,
    'Gestão Interna' AS responsavel
FROM
    INDISPONIBILIDADES i
JOIN VAGAS v ON i.id_vaga = v.id_vaga
JOIN QUARTOS q ON v.id_quarto = q.id_quarto
WHERE
    i.id_vaga IS NOT NULL
    AND i.data_inicio < @data_fim_desejada
    AND i.data_fim > @data_inicio_desejada

ORDER BY
    nome_quarto, identificador_vaga;
