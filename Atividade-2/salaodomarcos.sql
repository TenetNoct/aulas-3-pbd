-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 27/05/2025 às 01:13
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `salaodomarcos`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamentos`
--

CREATE TABLE `agendamentos` (
  `agendamento_id` int(10) UNSIGNED NOT NULL,
  `cliente_id` int(10) UNSIGNED NOT NULL COMMENT 'Cliente que fez a reserva',
  `servico_id` int(10) UNSIGNED NOT NULL COMMENT 'Serviço agendado',
  `profissional_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Profissional escolhido (NULL se "qualquer disponível")',
  `data_hora_inicio` datetime NOT NULL COMMENT 'Data e hora exatas do início do serviço',
  `data_hora_fim` datetime NOT NULL COMMENT 'Data e hora calculadas do fim do serviço (populada via aplicação/trigger)',
  `status_agendamento` varchar(20) NOT NULL COMMENT 'Status (Agendado, Confirmado, Concluído, etc.)',
  `valor_cobrado` decimal(10,2) NOT NULL COMMENT 'Valor efetivamente cobrado no momento da reserva',
  `data_criacao` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Quando a reserva foi criada no sistema',
  `observacoes` varchar(500) DEFAULT NULL COMMENT 'Notas adicionais'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `centros_servico`
--

CREATE TABLE `centros_servico` (
  `centro_id` int(10) UNSIGNED NOT NULL,
  `nome` varchar(100) NOT NULL COMMENT 'Nome do centro (ex: Salão de Beleza)',
  `descricao` varchar(500) DEFAULT NULL COMMENT 'Descrição opcional do centro'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Identifica as unidades de negócio (Salão, Estética)';

-- --------------------------------------------------------

--
-- Estrutura para tabela `clientes`
--

CREATE TABLE `clientes` (
  `cliente_id` int(10) UNSIGNED NOT NULL,
  `nome_completo` varchar(200) NOT NULL COMMENT 'Nome do cliente',
  `email` varchar(100) NOT NULL COMMENT 'Email para login e comunicação',
  `telefone` varchar(20) DEFAULT NULL COMMENT 'Telefone de contato',
  `senha_hash` varchar(255) NOT NULL COMMENT 'Hash da senha para login seguro',
  `data_cadastro` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Data e hora do cadastro',
  `saldo_credito` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Saldo de crédito por não comparecimento'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `especialidades_profissional`
--

CREATE TABLE `especialidades_profissional` (
  `profissional_id` int(10) UNSIGNED NOT NULL,
  `servico_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabela de junção (N:N) entre PROFISSIONAIS e SERVICOS';

-- --------------------------------------------------------

--
-- Estrutura para tabela `fila_espera`
--

CREATE TABLE `fila_espera` (
  `fila_espera_id` int(10) UNSIGNED NOT NULL,
  `cliente_id` int(10) UNSIGNED NOT NULL COMMENT 'Cliente na fila',
  `servico_desejado_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Serviço que o cliente deseja (opcional)',
  `profissional_desejado_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Profissional desejado (opcional)',
  `data_hora_chegada` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Momento em que o cliente entrou na fila',
  `status_fila` varchar(20) NOT NULL DEFAULT 'Aguardando' COMMENT 'Status na fila (Aguardando, Chamado, etc.)'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `horarios_trabalho_profissional`
--

CREATE TABLE `horarios_trabalho_profissional` (
  `horario_trab_id` int(10) UNSIGNED NOT NULL,
  `profissional_id` int(10) UNSIGNED NOT NULL COMMENT 'Profissional associado',
  `dia_semana` tinyint(3) UNSIGNED NOT NULL COMMENT 'Dia da semana (ex: 1=Domingo, 2=Segunda... 7=Sábado)',
  `hora_inicio` time NOT NULL COMMENT 'Hora de início no formato HH:MM',
  `hora_fim` time NOT NULL COMMENT 'Hora de fim no formato HH:MM'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pacotes_servico`
--

CREATE TABLE `pacotes_servico` (
  `pacote_id` int(10) UNSIGNED NOT NULL,
  `nome` varchar(150) NOT NULL COMMENT 'Nome do pacote',
  `descricao` text DEFAULT NULL COMMENT 'Descrição do pacote',
  `preco_pacote` decimal(10,2) NOT NULL COMMENT 'Preço total do pacote',
  `ativo` char(1) NOT NULL DEFAULT 'S' COMMENT 'Flag de ativação (S/N)'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pagamentos`
--

CREATE TABLE `pagamentos` (
  `pagamento_id` int(10) UNSIGNED NOT NULL,
  `agendamento_id` int(10) UNSIGNED NOT NULL COMMENT 'Agendamento associado (Relacionamento 1:1)',
  `valor_pago` decimal(10,2) NOT NULL COMMENT 'Valor processado',
  `data_pagamento` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Data e hora da transação',
  `status_pagamento` varchar(25) NOT NULL COMMENT 'Status (Processado, Falha, Reembolsado Parcial, Reembolsado Total)',
  `id_transacao_gateway` varchar(100) NOT NULL COMMENT 'ID da transação retornado pelo gateway',
  `ultimos4_cartao` varchar(4) DEFAULT NULL COMMENT 'Últimos 4 dígitos do cartão',
  `bandeira_cartao` varchar(50) DEFAULT NULL COMMENT 'Bandeira (Visa, Mastercard, etc.)'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `profissionais`
--

CREATE TABLE `profissionais` (
  `profissional_id` int(10) UNSIGNED NOT NULL,
  `nome_completo` varchar(200) NOT NULL COMMENT 'Nome do profissional',
  `email_corporativo` varchar(100) DEFAULT NULL COMMENT 'Email corporativo opcional',
  `telefone` varchar(20) DEFAULT NULL COMMENT 'Telefone opcional',
  `data_contratacao` date DEFAULT NULL COMMENT 'Data de contratação',
  `ativo` char(1) NOT NULL DEFAULT 'S' COMMENT 'Flag indicando se o profissional está ativo (S/N)'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `servicos`
--

CREATE TABLE `servicos` (
  `servico_id` int(10) UNSIGNED NOT NULL,
  `centro_id` int(10) UNSIGNED NOT NULL COMMENT 'Centro onde o serviço é primariamente oferecido',
  `nome` varchar(150) NOT NULL COMMENT 'Nome do serviço (ex: Manicure)',
  `descricao` text DEFAULT NULL COMMENT 'Descrição detalhada do serviço',
  `duracao_minutos` smallint(5) UNSIGNED NOT NULL COMMENT 'Duração fixa do serviço em minutos',
  `preco` decimal(10,2) NOT NULL COMMENT 'Preço do serviço',
  `ativo` char(1) NOT NULL DEFAULT 'S' COMMENT 'Flag indicando se o serviço está ativo (S/N)'
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `servicos_do_pacote`
--

CREATE TABLE `servicos_do_pacote` (
  `pacote_id` int(10) UNSIGNED NOT NULL,
  `servico_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabela de junção (N:N) entre PACOTES_SERVICO e SERVICOS';

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD PRIMARY KEY (`agendamento_id`),
  ADD KEY `fk_agendamento_servico` (`servico_id`),
  ADD KEY `fk_agendamento_profissional` (`profissional_id`),
  ADD KEY `idx_agend_data_hora_inicio_prof` (`data_hora_inicio`,`profissional_id`),
  ADD KEY `idx_agend_data_hora_inicio_serv` (`data_hora_inicio`,`servico_id`),
  ADD KEY `idx_agend_cliente_data_hora` (`cliente_id`,`data_hora_inicio`),
  ADD KEY `idx_agend_status` (`status_agendamento`),
  ADD KEY `idx_agend_data_hora_inicio` (`data_hora_inicio`);

--
-- Índices de tabela `centros_servico`
--
ALTER TABLE `centros_servico`
  ADD PRIMARY KEY (`centro_id`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices de tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`cliente_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `especialidades_profissional`
--
ALTER TABLE `especialidades_profissional`
  ADD PRIMARY KEY (`profissional_id`,`servico_id`),
  ADD KEY `fk_esp_servico` (`servico_id`);

--
-- Índices de tabela `fila_espera`
--
ALTER TABLE `fila_espera`
  ADD PRIMARY KEY (`fila_espera_id`),
  ADD KEY `fk_fila_cliente` (`cliente_id`),
  ADD KEY `fk_fila_servico` (`servico_desejado_id`),
  ADD KEY `fk_fila_profissional` (`profissional_desejado_id`),
  ADD KEY `idx_fila_data_chegada` (`data_hora_chegada`),
  ADD KEY `idx_fila_status_data_chegada` (`status_fila`,`data_hora_chegada`);

--
-- Índices de tabela `horarios_trabalho_profissional`
--
ALTER TABLE `horarios_trabalho_profissional`
  ADD PRIMARY KEY (`horario_trab_id`),
  ADD UNIQUE KEY `uk_prof_dia_hora` (`profissional_id`,`dia_semana`,`hora_inicio`);

--
-- Índices de tabela `pacotes_servico`
--
ALTER TABLE `pacotes_servico`
  ADD PRIMARY KEY (`pacote_id`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices de tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD PRIMARY KEY (`pagamento_id`),
  ADD UNIQUE KEY `agendamento_id` (`agendamento_id`),
  ADD UNIQUE KEY `id_transacao_gateway` (`id_transacao_gateway`);

--
-- Índices de tabela `profissionais`
--
ALTER TABLE `profissionais`
  ADD PRIMARY KEY (`profissional_id`),
  ADD UNIQUE KEY `email_corporativo` (`email_corporativo`),
  ADD KEY `idx_profissionais_nome` (`nome_completo`);

--
-- Índices de tabela `servicos`
--
ALTER TABLE `servicos`
  ADD PRIMARY KEY (`servico_id`),
  ADD KEY `fk_servico_centro` (`centro_id`),
  ADD KEY `idx_servicos_nome` (`nome`);

--
-- Índices de tabela `servicos_do_pacote`
--
ALTER TABLE `servicos_do_pacote`
  ADD PRIMARY KEY (`pacote_id`,`servico_id`),
  ADD KEY `fk_srpac_servico` (`servico_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  MODIFY `agendamento_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `centros_servico`
--
ALTER TABLE `centros_servico`
  MODIFY `centro_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `clientes`
--
ALTER TABLE `clientes`
  MODIFY `cliente_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `fila_espera`
--
ALTER TABLE `fila_espera`
  MODIFY `fila_espera_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `horarios_trabalho_profissional`
--
ALTER TABLE `horarios_trabalho_profissional`
  MODIFY `horario_trab_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pacotes_servico`
--
ALTER TABLE `pacotes_servico`
  MODIFY `pacote_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  MODIFY `pagamento_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `profissionais`
--
ALTER TABLE `profissionais`
  MODIFY `profissional_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `servicos`
--
ALTER TABLE `servicos`
  MODIFY `servico_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD CONSTRAINT `fk_agendamento_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`),
  ADD CONSTRAINT `fk_agendamento_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`profissional_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_agendamento_servico` FOREIGN KEY (`servico_id`) REFERENCES `servicos` (`servico_id`);

--
-- Restrições para tabelas `especialidades_profissional`
--
ALTER TABLE `especialidades_profissional`
  ADD CONSTRAINT `fk_esp_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`profissional_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_esp_servico` FOREIGN KEY (`servico_id`) REFERENCES `servicos` (`servico_id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `fila_espera`
--
ALTER TABLE `fila_espera`
  ADD CONSTRAINT `fk_fila_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fila_profissional` FOREIGN KEY (`profissional_desejado_id`) REFERENCES `profissionais` (`profissional_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_fila_servico` FOREIGN KEY (`servico_desejado_id`) REFERENCES `servicos` (`servico_id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `horarios_trabalho_profissional`
--
ALTER TABLE `horarios_trabalho_profissional`
  ADD CONSTRAINT `fk_horario_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`profissional_id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD CONSTRAINT `fk_pagamento_agendamento` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamentos` (`agendamento_id`);

--
-- Restrições para tabelas `servicos`
--
ALTER TABLE `servicos`
  ADD CONSTRAINT `fk_servico_centro` FOREIGN KEY (`centro_id`) REFERENCES `centros_servico` (`centro_id`);

--
-- Restrições para tabelas `servicos_do_pacote`
--
ALTER TABLE `servicos_do_pacote`
  ADD CONSTRAINT `fk_srpac_pacote` FOREIGN KEY (`pacote_id`) REFERENCES `pacotes_servico` (`pacote_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_srpac_servico` FOREIGN KEY (`servico_id`) REFERENCES `servicos` (`servico_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
