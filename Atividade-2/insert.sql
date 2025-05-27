INSERT INTO `profissionais`(`profissional_id`, `nome_completo`, `email_corporativo`, `telefone`, `data_contratacao`, `ativo`) VALUES
(101, 'Marcia Cabeleireira', 'marcia.cabelos@salaodomarcos.com', '5521987654321', '2022-05-10', 'S'),
(102, 'Claudia Manicure', 'claudia.unhas@salaodomarcos.com', '5521998765432', '2021-09-20', 'S'),
(103, 'Roberto Barbeiro', 'roberto.barber@salaodomarcos.com', '5521976543210', '2023-01-25', 'N');

INSERT INTO `centro_servico`(`centro_id`, `nome`, `descricao`) VALUES
(1, 'Salão Beleza Divina', 'Um espaço completo para cuidados capilares, unhas e estética.'),
(2, 'Barbearia Clássica do Roberto', 'Barbearia tradicional especializada em cortes masculinos e barba.'),
(3, 'Spa Urbano Renovare', 'Um oásis de tranquilidade com serviços de massagem e relaxamento.');

INSERT INTO `servicos`(`servico_id`, `centro_id`, `nome`, `descricao`, `duracao_minutos`, `preco`, `ativo`) VALUES
(206, 1, 'Maquiagem Profissional', 'Aplicação de maquiagem para eventos especiais.', 75, 120.00, 'S'),
(207, 1, 'Tratamento de Hidratação Capilar', 'Hidratação profunda para cabelos danificados.', 90, 90.00, 'S'),
(208, 1, 'Depilação Completa', 'Remoção de pelos corporais com cera quente/fria.', 120, 180.00, 'S'),
(209, 2, 'Corte Masculino Clássico', 'Corte de cabelo masculino com acabamento tradicional.', 45, 50.00, 'S'),
(210, 2, 'Design de Sobrancelhas Masculino', 'Modelagem de sobrancelhas para homens.', 30, 35.00, 'S'),
(211, 3, 'Massagem Relaxante', 'Massagem corporal completa para alívio do estresse.', 60, 150.00, 'S'),
(212, 3, 'Limpeza de Pele Facial', 'Limpeza profunda com extração e hidratação.', 90, 110.00, 'S');

INSERT INTO `especialidades_profissional`(`profissional_id`, `servico_id`) VALUES
(101, 206),
(101, 207), 
(101, 208), 
(103, 209), 
(103, 210); 
