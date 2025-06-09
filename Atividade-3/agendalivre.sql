SELECT
    p.nome_completo AS "Profissional",
    h.hora_inicio AS "Início do Expediente",
    h.hora_fim AS "Fim do Expediente",
    a.data_hora_inicio AS "Início do Agendamento",
    a.data_hora_fim AS "Fim do Agendamento"
FROM
    profissionais p
JOIN
    horarios_trabalho_profissional h ON p.profissional_id = h.profissional_id
LEFT JOIN
    agendamentos a ON p.profissional_id = a.profissional_id AND DATE(a.data_hora_inicio) = '2025-06-10'
WHERE
    p.ativo = 'S' AND h.dia_semana = WEEKDAY('2025-06-10') + 2
ORDER BY
    p.nome_completo, a.data_hora_inicio;