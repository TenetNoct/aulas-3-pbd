/*
 * ===================================================================================
 * SCRIPT DE CRIAÇÃO DO BANCO DE DADOS
 * PROJETO: Trabalho AV2 - Sistema de Reservas para Albergue (XPTOTec) - FAETERJ-RIO
 * AUTOR: Fellype Samuel Dos Santos de Melo - 24104708360042
 * DATA DE CRIAÇÃO: 2025-06-19
 * ===================================================================================
*/

-- Criação do banco de dados, se ele não existir
CREATE DATABASE IF NOT EXISTS albergue_xpto
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Seleciona o banco de dados para uso
USE albergue_xpto;


-- Tabela 1: USUARIOS
-- Armazena os dados dos clientes que realizam as reservas.
CREATE TABLE IF NOT EXISTS USUARIOS (
    id_usuario INT AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_usuario),
    UNIQUE KEY uq_email (email)
) ENGINE=InnoDB;


-- Tabela 2: QUARTOS
-- Descreve os quartos físicos do albergue.
CREATE TABLE IF NOT EXISTS QUARTOS (
    id_quarto INT AUTO_INCREMENT,
    nome_quarto VARCHAR(100) NOT NULL,
    descricao TEXT NULL,
    possui_banheiro BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id_quarto)
) ENGINE=InnoDB;


-- Tabela 3: VAGAS
-- Descreve cada vaga (cama) individualmente, contida em um quarto.
CREATE TABLE IF NOT EXISTS VAGAS (
    id_vaga INT AUTO_INCREMENT,
    id_quarto INT NOT NULL,
    identificador_vaga VARCHAR(50) NOT NULL,
    preco_padrao DECIMAL(10, 2) NOT NULL,
    ativa BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id_vaga),
    CONSTRAINT fk_vagas_quartos FOREIGN KEY (id_quarto) REFERENCES QUARTOS(id_quarto) ON DELETE RESTRICT
) ENGINE=InnoDB;


-- Tabela 4: TIPOS_CARACTERISTICA
-- Categoriza os tipos de características (ex: Posição, Tipo de Cama).
CREATE TABLE IF NOT EXISTS TIPOS_CARACTERISTICA (
    id_tipo_caracteristica INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (id_tipo_caracteristica),
    UNIQUE KEY uq_tipo_caracteristica_nome (nome)
) ENGINE=InnoDB;


-- Tabela 5: CARACTERISTICAS
-- Armazena as características específicas (ex: Perto da Janela, Beliche).
CREATE TABLE IF NOT EXISTS CARACTERISTICAS (
    id_caracteristica INT AUTO_INCREMENT,
    id_tipo_caracteristica INT NOT NULL,
    nome VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_caracteristica),
    UNIQUE KEY uq_caracteristica_nome (nome),
    CONSTRAINT fk_caracteristicas_tipos FOREIGN KEY (id_tipo_caracteristica) REFERENCES TIPOS_CARACTERISTICA(id_tipo_caracteristica) ON DELETE RESTRICT
) ENGINE=InnoDB;


-- Tabela 6: VAGA_CARACTERISTICAS
-- Tabela de ligação Muitos-para-Muitos entre VAGAS e CARACTERISTICAS.
CREATE TABLE IF NOT EXISTS VAGA_CARACTERISTICAS (
    id_vaga INT NOT NULL,
    id_caracteristica INT NOT NULL,

    PRIMARY KEY (id_vaga, id_caracteristica),
    CONSTRAINT fk_vc_vagas FOREIGN KEY (id_vaga) REFERENCES VAGAS(id_vaga) ON DELETE CASCADE,
    CONSTRAINT fk_vc_caracteristicas FOREIGN KEY (id_caracteristica) REFERENCES CARACTERISTICAS(id_caracteristica) ON DELETE CASCADE
) ENGINE=InnoDB;


-- Tabela 7: RESERVAS
-- Entidade central que registra cada reserva feita por um usuário.
CREATE TABLE IF NOT EXISTS RESERVAS (
    id_reserva INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    status_reserva ENUM('Pendente', 'Confirmada', 'Cancelada', 'Concluída') NOT NULL,
    tipo_reserva ENUM('VAGA_AVULSA', 'QUARTO_INTEIRO') NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_reserva),
    CONSTRAINT fk_reservas_usuarios FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario) ON DELETE RESTRICT,
    -- Índice crucial para performance de buscas por disponibilidade
    INDEX idx_datas_reserva (data_inicio, data_fim)
) ENGINE=InnoDB;


-- Tabela 8: RESERVA_VAGAS
-- Tabela de ligação Muitos-para-Muitos entre RESERVAS e VAGAS.
CREATE TABLE IF NOT EXISTS RESERVA_VAGAS (
    id_reserva INT NOT NULL,
    id_vaga INT NOT NULL,
    preco_diaria_registrado DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (id_reserva, id_vaga),
    CONSTRAINT fk_rv_reservas FOREIGN KEY (id_reserva) REFERENCES RESERVAS(id_reserva) ON DELETE CASCADE,
    CONSTRAINT fk_rv_vagas FOREIGN KEY (id_vaga) REFERENCES VAGAS(id_vaga) ON DELETE RESTRICT
) ENGINE=InnoDB;


-- Tabela 9: PAGAMENTOS
-- Registra todas as transações financeiras associadas a uma reserva.
CREATE TABLE IF NOT EXISTS PAGAMENTOS (
    id_pagamento INT AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    id_transacao_gateway VARCHAR(255) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    status_pagamento ENUM('Aprovado', 'Recusado', 'Estornado', 'Pendente') NOT NULL,
    data_pagamento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id_pagamento),
    CONSTRAINT fk_pagamentos_reservas FOREIGN KEY (id_reserva) REFERENCES RESERVAS(id_reserva) ON DELETE RESTRICT
) ENGINE=InnoDB;


-- Tabela 10: AVALIACOES
-- Armazena o feedback (reviews) dos hóspedes sobre sua estadia.
CREATE TABLE IF NOT EXISTS AVALIACOES (
    id_avaliacao INT AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    nota_geral TINYINT UNSIGNED NOT NULL,
    comentario TEXT NULL,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_avaliacao),
    UNIQUE KEY uq_avaliacao_reserva (id_reserva),
    CONSTRAINT fk_avaliacoes_reservas FOREIGN KEY (id_reserva) REFERENCES RESERVAS(id_reserva) ON DELETE CASCADE,
    CONSTRAINT chk_nota CHECK (nota_geral BETWEEN 1 AND 5)
) ENGINE=InnoDB;


-- Tabela 11: TARIFAS
-- Permite a gestão de preços dinâmicos para períodos específicos (alta temporada, etc.).
CREATE TABLE IF NOT EXISTS TARIFAS (
    id_tarifa INT AUTO_INCREMENT,
    id_vaga INT NULL,
    id_quarto INT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    preco_diaria DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (id_tarifa),
    CONSTRAINT fk_tarifas_vagas FOREIGN KEY (id_vaga) REFERENCES VAGAS(id_vaga) ON DELETE CASCADE,
    CONSTRAINT fk_tarifas_quartos FOREIGN KEY (id_quarto) REFERENCES QUARTOS(id_quarto) ON DELETE CASCADE,
    INDEX idx_datas_tarifa (data_inicio, data_fim)
) ENGINE=InnoDB;


-- Tabela 12: INDISPONIBILIDADES
-- Agenda bloqueios operacionais para vagas ou quartos (manutenção, limpeza, etc.).
CREATE TABLE IF NOT EXISTS INDISPONIBILIDADES (
    id_indisponibilidade INT AUTO_INCREMENT,
    id_vaga INT NULL,
    id_quarto INT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    motivo VARCHAR(255) NOT NULL,

    PRIMARY KEY (id_indisponibilidade),
    CONSTRAINT fk_indisponibilidades_vagas FOREIGN KEY (id_vaga) REFERENCES VAGAS(id_vaga) ON DELETE CASCADE,
    CONSTRAINT fk_indisponibilidades_quartos FOREIGN KEY (id_quarto) REFERENCES QUARTOS(id_quarto) ON DELETE CASCADE,
    INDEX idx_datas_indisponibilidade (data_inicio, data_fim)
) ENGINE=InnoDB;
