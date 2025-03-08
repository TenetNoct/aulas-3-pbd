/* Criação do Banco de Dados*/

CREATE DATABASE IF NOT EXISTS `escola`;
USE `escola`;

/*  Criação da Tabela Alunos */
CREATE TABLE `escola`.`alunos` (`matrícula` INT NOT NULL AUTO_INCREMENT , `nome` VARCHAR(128) NOT NULL , `email` VARCHAR(48) NOT NULL , `cpf` VARCHAR(14) NOT NULL , PRIMARY KEY (`matrícula`)) ENGINE = InnoDB;

/*  Criação da Tabela Disciplinas */
CREATE TABLE `escola`.`disciplina` (`sigla` VARCHAR(4) NOT NULL , `nome` VARCHAR(128) NOT NULL , `cargaHoraria` MEDIUMINT NOT NULL , `periodo` TINYINT NOT NULL , `limDeFalta` SMALLINT NOT NULL ) ENGINE = InnoDB;

/*  CRUDE - Tabela Alunos */

INSERT INTO `alunos` (`matrícula`, `nome`, `email`, `cpf`) VALUES ('00000000', 'Fellype Samuel', 'example@example.com', '111.111.111-11')
UPDATE `alunos` SET `nome` = 'Pedro Souza', `cpf` = '111.111.111-12' WHERE `alunos`.`matrícula` = 2
DELETE FROM `alunos` WHERE `alunos`.`matrícula` = 2;
SELECT * FROM `alunos` WHERE `matrícula` = 1

/*  CRUDE - Tabela Disciplinas */

INSERT INTO `disciplina` (`sigla`, `nome`, `cargaHoraria`, `periodo`, `limDeFalta`) VALUES ('3PBD', '3 Banco de Dados', '80', '3', '10')
UPDATE `disciplina` SET `nome` = '3 Banco de Dados', `cargaHoraria` = '80', `periodo` = '3', `limDeFalta` = '20' WHERE `disciplina`.`sigla` = '3PBD'
SELECT * FROM `disciplina` WHERE `sigla` = '3PBD'
DELETE FROM `disciplina` WHERE `disciplina`.`sigla` = '3PBD'