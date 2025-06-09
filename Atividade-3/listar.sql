SELECT
    p.nome_completo AS "Profissional",
    c.nome_completo AS "Cliente",
    a.data_hora_inicio AS "Início do Agendamento",
    a.data_hora_fim AS "Fim do Agendamento",
    a.status_agendamento AS "Status"
FROM
    agendamentos a
JOIN
    profissionais p ON a.profissional_id = p.profissional_id
JOIN
    clientes c ON a.cliente_id = c.cliente_id
ORDER BY
    p.nome_completo, a.data_hora_inicio;