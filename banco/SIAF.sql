-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 30, 2017 at 02:22 
-- Server version: 10.1.21-MariaDB
-- PHP Version: 7.0.15



/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `SIAF`
--

DELIMITER $$
--
-- Procedures
--
CREATE PROCEDURE `processarMatriculas` ()  BEGIN

DECLARE existe_mais_linhas INT DEFAULT 0;
DECLARE cIdTurma INT(19);
DECLARE cCapacidade INT(11);
DECLARE meuCursor CURSOR FOR SELECT idTurma, capacidade 
							 FROM turma
                             WHERE idTurmaSituacao = 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET existe_mais_linhas=1;

START TRANSACTION;
set autocommit=0;

OPEN meuCursor;

meuLoop: LOOP
  FETCH meuCursor INTO cIdTurma, cCapacidade;
  
  IF existe_mais_linhas = 1 THEN
  LEAVE meuLoop;
  END IF;	
  
  UPDATE matricula
  SET idMatriculaSituacao = 2
  WHERE idTurma = cIdTurma AND idMatriculaSituacao = 1
  LIMIT cCapacidade;
  
  UPDATE matricula
  SET idMatriculaSituacao = 3
  WHERE idTurma = cIdTurma AND idMatriculaSituacao = 1;
  
  UPDATE turma
  SET idTurmaSituacao = 2
  WHERE idTurma = cIdTurma;
  
  UPDATE periodoMatricula
  SET processamento = now();
  
END LOOP meuLoop;

CLOSE meuCursor;

COMMIT;
set autocommit=1;

END$$

--
-- Functions
--
CREATE  FUNCTION `Func_CalculaQtdMatriculasPorTurma` (`turma` INT(19)) RETURNS INT(19) BEGIN
DECLARE MATRICULADOS INT;
SELECT COUNT(*) INTO MATRICULADOS FROM matricula WHERE idTurma = turma;

RETURN MATRICULADOS;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `aluno`
--

CREATE TABLE `aluno` (
  `idAluno` int(19) NOT NULL,
  `idPessoa` int(19) NOT NULL,
  `idCurso` int(19) NOT NULL,
  `idIntinerarioFormativo` int(19) NOT NULL,
  `idVinculoSituacao` int(19) NOT NULL,
  `matricula` int(19) NOT NULL,
  `anoIngresso` date NOT NULL,
  `periodoIngresso` int(11) NOT NULL
);

--
-- Dumping data for table `aluno`
--

INSERT INTO `aluno` (`idAluno`, `idPessoa`, `idCurso`, `idIntinerarioFormativo`, `idVinculoSituacao`, `matricula`, `anoIngresso`, `periodoIngresso`) VALUES
(1, 1, 1, 1, 1, 1000, '2015-01-01', 1),
(5, 5, 1, 1, 1, 444, '2012-01-01', 1);

-- --------------------------------------------------------

--
-- Table structure for table `curso`
--

CREATE TABLE `curso` (
  `idCurso` int(19) NOT NULL,
  `idTitulacao` int(19) NOT NULL,
  `nome` varchar(250) NOT NULL,
  `cargaHoraria` int(19) NOT NULL,
  `duracaoEmSemestres` int(19) NOT NULL,
  `ativo` char(1) NOT NULL DEFAULT '1'
);

--
-- Dumping data for table `curso`
--

INSERT INTO `curso` (`idCurso`, `idTitulacao`, `nome`, `cargaHoraria`, `duracaoEmSemestres`, `ativo`) VALUES
(1, 1, 'ABI em Computação', 3000, 6, '1');

-- --------------------------------------------------------

--
-- Table structure for table `disciplina`
--

CREATE TABLE `disciplina` (
  `idDisciplina` int(19) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `cargaHoraria` int(6) NOT NULL,
  `sigla` varchar(10) NOT NULL
);

--
-- Dumping data for table `disciplina`
--

INSERT INTO `disciplina` (`idDisciplina`, `nome`, `cargaHoraria`, `sigla`) VALUES
(1, 'Leitura e Produção de Textos', 72, 'LPT'),
(2, 'Lógica Matemática', 72, 'LGM'),
(3, 'Cálculo Diferencial e Integral I', 72, 'CA1'),
(4, 'Cálculo Diferencial e Integral II', 72, 'CA2'),
(5, 'Cálculo Diferencial e Integral III', 72, 'CA3'),
(6, 'Algoritmos e Programação de Computadores', 72, 'APC'),
(7, 'Probabilidade e Estatistica', 72, 'PBE'),
(8, 'Álgebra Linear', 72, 'ALL'),
(9, 'Cultura e Sociedade', 72, 'CUS'),
(10, 'Fundamentos da educação', 72, 'FED'),
(11, 'Arquitetura de computadores I', 72, 'ARC1'),
(12, 'Arquitetura de computadores II', 72, 'ARC1'),
(13, 'Programação de Computadores I', 72, 'PC1'),
(14, 'Programação de Computadores II', 72, 'PC2'),
(15, 'Programação de Computadores III', 72, 'PC3'),
(16, 'Cálculo Numérico', 72, 'CN'),
(17, 'Matemática Discreta', 72, 'MDC'),
(18, 'Inglês Técnico', 72, 'IGT'),
(19, 'Metodologia Científica', 72, 'MTC'),
(20, 'Física para Computação', 72, 'FCU'),
(21, 'Estrutura de Dados e Algoritmos', 72, 'EDA'),
(22, 'Banco de Dados I', 72, 'BD1'),
(23, 'Banco de Dados II', 72, 'BD2');

-- --------------------------------------------------------

--
-- Table structure for table `disciplinaIntinerario`
--

CREATE TABLE `disciplinaIntinerario` (
  `idDisciplinaIntinerario` int(19) NOT NULL,
  `idDisciplina` int(19) NOT NULL,
  `idIntinerarioFormativo` int(19) NOT NULL,
  `periodo` int(11) NOT NULL,
  `obrigatorio` char(1) NOT NULL DEFAULT '0'
);

--
-- Dumping data for table `disciplinaIntinerario`
--

INSERT INTO `disciplinaIntinerario` (`idDisciplinaIntinerario`, `idDisciplina`, `idIntinerarioFormativo`, `periodo`, `obrigatorio`) VALUES
(1, 1, 1, 1, '1'),
(2, 2, 1, 1, '1'),
(3, 3, 1, 1, '1'),
(4, 4, 1, 2, '1'),
(5, 5, 1, 3, '1'),
(6, 6, 1, 1, '1'),
(7, 7, 1, 1, '1'),
(8, 8, 1, 1, '1'),
(9, 9, 1, 1, '1'),
(10, 10, 1, 2, '1'),
(11, 11, 1, 2, '1'),
(12, 12, 1, 3, '1'),
(13, 13, 1, 2, '1'),
(14, 14, 1, 3, '1'),
(15, 15, 1, 4, '1'),
(16, 16, 1, 2, '1'),
(17, 17, 1, 2, '1'),
(18, 18, 1, 2, '1'),
(19, 19, 1, 3, '1'),
(20, 20, 1, 3, '1'),
(21, 21, 1, 3, '1'),
(22, 22, 1, 3, '1'),
(23, 23, 1, 4, '1');

-- --------------------------------------------------------

--
-- Table structure for table `historico`
--

CREATE TABLE `historico` (
  `idHistorico` int(19) NOT NULL,
  `idAluno` int(19) NOT NULL,
  `idDisciplina` int(19) NOT NULL,
  `ano` date NOT NULL,
  `periodo` int(11) NOT NULL,
  `situacao` char(1) NOT NULL DEFAULT '0'
);

-- --------------------------------------------------------

--
-- Table structure for table `intinerarioFormativo`
--

CREATE TABLE `intinerarioFormativo` (
  `idIntinerarioFormativo` int(19) NOT NULL,
  `idCurso` int(19) NOT NULL,
  `inicio` date NOT NULL,
  `fim` date DEFAULT NULL,
  `ativo` char(1) NOT NULL DEFAULT '0'
);

--
-- Dumping data for table `intinerarioFormativo`
--

INSERT INTO `intinerarioFormativo` (`idIntinerarioFormativo`, `idCurso`, `inicio`, `fim`, `ativo`) VALUES
(1, 1, '2014-01-01', NULL, '0');

-- --------------------------------------------------------

--
-- Table structure for table `matricula`
--

CREATE TABLE `matricula` (
  `idMatricula` int(19) NOT NULL,
  `idAluno` int(19) NOT NULL,
  `idTurma` int(19) NOT NULL,
  `idMatriculaSituacao` int(19) NOT NULL,
  `dataSolicitacao` datetime NOT NULL
);

--
-- Dumping data for table `matricula`
--

INSERT INTO `matricula` (`idMatricula`, `idAluno`, `idTurma`, `idMatriculaSituacao`, `dataSolicitacao`) VALUES
(182, 5, 2, 1, '2017-06-29 03:55:11'),
(183, 5, 7, 1, '2017-06-29 03:55:11'),
(184, 5, 8, 1, '2017-06-29 03:55:11'),
(185, 5, 9, 1, '2017-06-29 03:55:11'),
(186, 5, 10, 1, '2017-06-29 03:55:11'),
(187, 5, 3, 1, '2017-06-29 03:55:11'),
(188, 5, 4, 1, '2017-06-29 03:55:11'),
(189, 5, 5, 1, '2017-06-29 03:55:11'),
(190, 5, 6, 1, '2017-06-29 03:55:11'),
(197, 1, 1, 1, '2017-06-29 17:19:44'),
(198, 1, 3, 1, '2017-06-29 17:19:44'),
(199, 1, 4, 1, '2017-06-29 17:19:44'),
(200, 1, 5, 1, '2017-06-29 17:19:44'),
(201, 1, 6, 1, '2017-06-29 17:19:44'),
(202, 1, 7, 1, '2017-06-29 17:19:44'),
(203, 1, 8, 1, '2017-06-29 17:19:44'),
(204, 1, 9, 1, '2017-06-29 17:19:44'),
(205, 1, 10, 1, '2017-06-29 17:19:44');

--
-- Triggers `matricula`
--
DELIMITER $$
CREATE TRIGGER `tgr_linhasDuplicadas` BEFORE INSERT ON `matricula` FOR EACH ROW BEGIN

DECLARE OUTRAS_MATRICULAS INT;
DECLARE disciplinaMatricula INT(19);
DECLARE anoMatricula date;
DECLARE periodoMatricula INT(11);
DECLARE msg VARCHAR(1000) DEFAULT "sem mensagem";
DECLARE excecao SMALLINT DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET excecao = 1;
   
SELECT idDisciplina, ano, periodo 
		INTO disciplinaMatricula, anoMatricula, periodoMatricula 
FROM turma WHERE idTurma = NEW.idTurma;

SELECT COUNT(*) INTO OUTRAS_MATRICULAS FROM matricula m
inner join turma t on t.idTurma = m.idTurma
	inner join disciplina d on d.idDisciplina = t.idDisciplina
WHERE m.idAluno = NEW.idAluno
and m.idMatriculaSituacao = 1
and d.idDisciplina = disciplinaMatricula
and t.ano = anoMatricula
and t.periodo = periodoMatricula;
if OUTRAS_MATRICULAS > 0 THEN

SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Não é possível fazer duas matrículas para mesma disciplina!!';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `matriculaSituacao`
--

CREATE TABLE `matriculaSituacao` (
  `idMatriculaSituacao` int(19) NOT NULL,
  `descricao` varchar(150) NOT NULL
);

--
-- Dumping data for table `matriculaSituacao`
--

INSERT INTO `matriculaSituacao` (`idMatriculaSituacao`, `descricao`) VALUES
(1, 'Solicitada'),
(2, 'Deferida'),
(3, 'Indeferida');

-- --------------------------------------------------------

--
-- Table structure for table `perfil`
--

CREATE TABLE `perfil` (
  `idPerfil` int(19) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `ativo` char(1) NOT NULL DEFAULT '1'
);

--
-- Dumping data for table `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `nome`, `ativo`) VALUES
(1, 'ESTUDANTE', '1'),
(2, 'REGISTRO ACADÊMICO', '2'),
(3, 'PROFESSOR', '3'),
(4, 'ADMINISTRADOR', '4');

-- --------------------------------------------------------

--
-- Table structure for table `periodoMatricula`
--

CREATE TABLE `periodoMatricula` (
  `idPeriodoMatricula` int(19) NOT NULL,
  `idPessoa` int(19) NOT NULL,
  `ano` date NOT NULL,
  `periodo` int(11) NOT NULL,
  `inicio` date NOT NULL,
  `fim` date NOT NULL,
  `processamento` date DEFAULT NULL
);

--
-- Dumping data for table `periodoMatricula`
--

INSERT INTO `periodoMatricula` (`idPeriodoMatricula`, `idPessoa`, `ano`, `periodo`, `inicio`, `fim`, `processamento`) VALUES
(2, 1, '2017-01-01', 2, '2017-06-01', '2017-07-01', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pessoa`
--

CREATE TABLE `pessoa` (
  `idPessoa` int(19) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `cpf` char(11) NOT NULL,
  `dataNascimento` date DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(150) NOT NULL
);

--
-- Dumping data for table `pessoa`
--

INSERT INTO `pessoa` (`idPessoa`, `nome`, `cpf`, `dataNascimento`, `email`, `senha`) VALUES
(1, 'George Araújo', '07894582417', '0000-00-00', 'george.ifrn@gmail.com', 'e10adc3949ba59abbe56e057f20f883e'),
(2, 'Raimundo CLaudio', '12345678901', '1900-12-12', 'raimundo@ifb.edu.br', 'e10adc3949ba59abbe56e057f20f883e'),
(3, 'Roberto Fontes', '12345678901', '1900-12-12', 'fontes@ifb.edu.br', 'e10adc3949ba59abbe56e057f20f883e'),
(4, 'Leandro Vaguetti', '12345678901', '1900-12-12', 'vaguetti@ifb.edu.br', 'e10adc3949ba59abbe56e057f20f883e'),
(5, 'teste', '12345678909', '1996-01-01', 'teste@teste.com', 'e10adc3949ba59abbe56e057f20f883e');

-- --------------------------------------------------------

--
-- Table structure for table `pessoaPerfil`
--

CREATE TABLE `pessoaPerfil` (
  `idPessoa` int(19) NOT NULL,
  `idPerfil` int(19) NOT NULL
);

--
-- Dumping data for table `pessoaPerfil`
--

INSERT INTO `pessoaPerfil` (`idPessoa`, `idPerfil`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `prerequisito`
--

CREATE TABLE `prerequisito` (
  `idPrerequisito` int(19) NOT NULL,
  `idDisciplinaIntinerario` int(19) NOT NULL,
  `idDisciplinaIntinerarioRequisito` int(19) NOT NULL
);

--
-- Dumping data for table `prerequisito`
--

INSERT INTO `prerequisito` (`idPrerequisito`, `idDisciplinaIntinerario`, `idDisciplinaIntinerarioRequisito`) VALUES
(1, 4, 3),
(2, 5, 4),
(3, 12, 11),
(4, 23, 22),
(5, 14, 13),
(6, 15, 14);

-- --------------------------------------------------------

--
-- Table structure for table `professor`
--

CREATE TABLE `professor` (
  `idProfessor` int(19) NOT NULL,
  `idPessoa` int(19) NOT NULL,
  `idVinculoSituacao` int(19) NOT NULL,
  `matricula` int(19) NOT NULL,
  `titulo` char(1) DEFAULT NULL
);

--
-- Dumping data for table `professor`
--

INSERT INTO `professor` (`idProfessor`, `idPessoa`, `idVinculoSituacao`, `matricula`, `titulo`) VALUES
(1, 2, 1, 222, 'M'),
(2, 3, 1, 333, 'M'),
(3, 4, 1, 444, '');

-- --------------------------------------------------------

--
-- Table structure for table `professoresTurma`
--

CREATE TABLE `professoresTurma` (
  `idProfessor` int(19) NOT NULL,
  `idTurma` int(19) NOT NULL,
  `cargaHoraria` int(11) NOT NULL
);

--
-- Dumping data for table `professoresTurma`
--

INSERT INTO `professoresTurma` (`idProfessor`, `idTurma`, `cargaHoraria`) VALUES
(1, 1, 72),
(1, 2, 72),
(1, 3, 72),
(1, 4, 72),
(2, 5, 72),
(2, 6, 72),
(2, 7, 72),
(2, 8, 72),
(3, 9, 72),
(3, 10, 72);

-- --------------------------------------------------------

--
-- Table structure for table `titulacao`
--

CREATE TABLE `titulacao` (
  `idTitulacao` int(19) NOT NULL,
  `descricao` varchar(150) NOT NULL
);

--
-- Dumping data for table `titulacao`
--

INSERT INTO `titulacao` (`idTitulacao`, `descricao`) VALUES
(1, 'Graduação');

-- --------------------------------------------------------

--
-- Table structure for table `turma`
--

CREATE TABLE `turma` (
  `idTurma` int(19) NOT NULL,
  `idDisciplina` int(19) NOT NULL,
  `idTurmaTipo` int(19) NOT NULL,
  `idTurmaSituacao` int(19) NOT NULL,
  `capacidade` int(11) NOT NULL,
  `horario` varchar(12) NOT NULL,
  `localAula` varchar(150) DEFAULT NULL,
  `ano` date NOT NULL,
  `periodo` int(11) NOT NULL,
  `numero` int(11) DEFAULT NULL
);

--
-- Dumping data for table `turma`
--

INSERT INTO `turma` (`idTurma`, `idDisciplina`, `idTurmaTipo`, `idTurmaSituacao`, `capacidade`, `horario`, `localAula`, `ano`, `periodo`, `numero`) VALUES
(1, 1, 1, 1, 1, '24M12', 'LAB B-3', '2017-01-01', 2, 1),
(2, 1, 3, 1, 1, '35M12', 'LAB B-3', '2017-01-01', 2, 2),
(3, 2, 1, 1, 1, '24M34', 'LAB B-4', '2017-01-01', 2, 1),
(4, 3, 1, 1, 1, '35M12', 'LAB B-3', '2017-01-01', 2, 1),
(5, 4, 1, 1, 1, '35M34', 'LAB B-3', '2017-01-01', 2, 1),
(6, 5, 1, 1, 1, '35M34', 'LAB B-1', '2017-01-01', 2, 1),
(7, 6, 1, 1, 1, '6M123456', 'LAB B-6', '2017-01-01', 2, 1),
(8, 7, 1, 1, 1, '35T12', 'LAB B-3', '2017-01-01', 2, 1),
(9, 8, 1, 1, 1, '35T34', 'LAB B-3', '2017-01-01', 2, 1),
(10, 9, 1, 1, 1, '12T12', 'LAB B-3', '2017-01-01', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `turmaSituacao`
--

CREATE TABLE `turmaSituacao` (
  `idTurmaSituacao` int(19) NOT NULL,
  `descricao` varchar(150) NOT NULL
);

--
-- Dumping data for table `turmaSituacao`
--

INSERT INTO `turmaSituacao` (`idTurmaSituacao`, `descricao`) VALUES
(1, 'Aberta'),
(2, 'Fechada');

-- --------------------------------------------------------

--
-- Table structure for table `turmaTipo`
--

CREATE TABLE `turmaTipo` (
  `idTurmaTipo` int(19) NOT NULL,
  `descricao` varchar(150) NOT NULL
);

--
-- Dumping data for table `turmaTipo`
--

INSERT INTO `turmaTipo` (`idTurmaTipo`, `descricao`) VALUES
(1, 'Regular'),
(2, 'Individual'),
(3, 'Extra');

-- --------------------------------------------------------

--
-- Table structure for table `vinculoSituacao`
--

CREATE TABLE `vinculoSituacao` (
  `idVinculoSituacao` int(19) NOT NULL,
  `descricao` varchar(150) NOT NULL
);

--
-- Dumping data for table `vinculoSituacao`
--

INSERT INTO `vinculoSituacao` (`idVinculoSituacao`, `descricao`) VALUES
(1, 'Ativo');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_turmas_matricula`
-- (See below for the actual view)
--
CREATE TABLE `vw_turmas_matricula` (
`QTD_MATRICULAS` int(19)
,`idTurma` int(19)
,`capacidade` int(11)
,`horario` varchar(12)
,`localAula` varchar(150)
,`ano` date
,`periodo` int(11)
,`numero` int(11)
,`nome` varchar(150)
,`cargaHoraria` int(6)
,`sigla` varchar(10)
,`TIPO_TURMA` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_usuario_logado`
-- (See below for the actual view)
--
CREATE TABLE `vw_usuario_logado` (
`idPessoa` int(19)
,`nome` varchar(150)
,`cpf` char(11)
,`dataNascimento` date
,`email` varchar(150)
,`senha` varchar(150)
,`is_estudante` int(1)
,`is_registro` int(1)
,`is_professor` int(1)
,`is_administrador` int(1)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_turmas_matricula`
--
DROP TABLE IF EXISTS `vw_turmas_matricula`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_turmas_matricula`  AS  select `Func_CalculaQtdMatriculasPorTurma`(`t`.`idTurma`) AS `QTD_MATRICULAS`,`t`.`idTurma` AS `idTurma`,`t`.`capacidade` AS `capacidade`,`t`.`horario` AS `horario`,`t`.`localAula` AS `localAula`,`t`.`ano` AS `ano`,`t`.`periodo` AS `periodo`,`t`.`numero` AS `numero`,`d`.`nome` AS `nome`,`d`.`cargaHoraria` AS `cargaHoraria`,`d`.`sigla` AS `sigla`,`tt`.`descricao` AS `TIPO_TURMA` from (((`turma` `t` join `disciplina` `d` on((`d`.`idDisciplina` = `t`.`idDisciplina`))) join `turmaTipo` `tt` on((`tt`.`idTurmaTipo` = `t`.`idTurmaTipo`))) join `periodoMatricula` `pm` on(((`pm`.`ano` = `t`.`ano`) and (`pm`.`periodo` = `t`.`periodo`)))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_usuario_logado`
--
DROP TABLE IF EXISTS `vw_usuario_logado`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_usuario_logado`  AS  select `ps`.`idPessoa` AS `idPessoa`,`ps`.`nome` AS `nome`,`ps`.`cpf` AS `cpf`,`ps`.`dataNascimento` AS `dataNascimento`,`ps`.`email` AS `email`,`ps`.`senha` AS `senha`,(select 1 from `pessoaPerfil` `PP` where ((`PP`.`idPessoa` = `ps`.`idPessoa`) and (`PP`.`idPerfil` = 1))) AS `is_estudante`,(select 1 from `pessoaPerfil` `PP` where ((`PP`.`idPessoa` = `ps`.`idPessoa`) and (`PP`.`idPerfil` = 2))) AS `is_registro`,(select 1 from `pessoaPerfil` `PP` where ((`PP`.`idPessoa` = `ps`.`idPessoa`) and (`PP`.`idPerfil` = 3))) AS `is_professor`,(select 1 from `pessoaPerfil` `PP` where ((`PP`.`idPessoa` = `ps`.`idPessoa`) and (`PP`.`idPerfil` = 4))) AS `is_administrador` from `pessoa` `ps` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aluno`
--
ALTER TABLE `aluno`
  ADD PRIMARY KEY (`idAluno`),
  ADD KEY `FK_ALUNO_PESSOA` (`idPessoa`),
  ADD KEY `FK_ALUNO_CURSO` (`idCurso`),
  ADD KEY `FK_ALUNO_INTINERARIOFORMATIVO` (`idIntinerarioFormativo`),
  ADD KEY `FK_ALUNO_VINCULOSITUACAO` (`idVinculoSituacao`);

--
-- Indexes for table `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`idCurso`),
  ADD KEY `FK_CURSO_TITULACAO` (`idTitulacao`);

--
-- Indexes for table `disciplina`
--
ALTER TABLE `disciplina`
  ADD PRIMARY KEY (`idDisciplina`);

--
-- Indexes for table `disciplinaIntinerario`
--
ALTER TABLE `disciplinaIntinerario`
  ADD PRIMARY KEY (`idDisciplinaIntinerario`),
  ADD KEY `FK_DISCIPLINAINTINERARIO_DISCIPLINA` (`idDisciplina`),
  ADD KEY `FK_DISCIPLINAINTINERARIO_INTINERARIO` (`idIntinerarioFormativo`);

--
-- Indexes for table `historico`
--
ALTER TABLE `historico`
  ADD PRIMARY KEY (`idHistorico`),
  ADD KEY `FK_HISTORICO_ALUNO` (`idAluno`),
  ADD KEY `FK_HISTORICO_DISCIPLINA` (`idDisciplina`);

--
-- Indexes for table `intinerarioFormativo`
--
ALTER TABLE `intinerarioFormativo`
  ADD PRIMARY KEY (`idIntinerarioFormativo`),
  ADD KEY `FK_INTINERARIO_CURSO` (`idCurso`);

--
-- Indexes for table `matricula`
--
ALTER TABLE `matricula`
  ADD PRIMARY KEY (`idMatricula`),
  ADD KEY `FK_MATRICULA_ALUNO` (`idAluno`),
  ADD KEY `FK_MATRICULA_TURMA` (`idTurma`),
  ADD KEY `FK_MATRICULA_MATRICULASITUACAO` (`idMatriculaSituacao`);

--
-- Indexes for table `matriculaSituacao`
--
ALTER TABLE `matriculaSituacao`
  ADD PRIMARY KEY (`idMatriculaSituacao`);

--
-- Indexes for table `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idPerfil`);

--
-- Indexes for table `periodoMatricula`
--
ALTER TABLE `periodoMatricula`
  ADD PRIMARY KEY (`idPeriodoMatricula`),
  ADD KEY `FK_PARIODOMATRICULA_PESSOA` (`idPessoa`);

--
-- Indexes for table `pessoa`
--
ALTER TABLE `pessoa`
  ADD PRIMARY KEY (`idPessoa`);

--
-- Indexes for table `pessoaPerfil`
--
ALTER TABLE `pessoaPerfil`
  ADD PRIMARY KEY (`idPessoa`,`idPerfil`),
  ADD KEY `FK_PESSOAPERFIL_PERFIL` (`idPerfil`);

--
-- Indexes for table `prerequisito`
--
ALTER TABLE `prerequisito`
  ADD PRIMARY KEY (`idPrerequisito`),
  ADD KEY `FK_PREREQUISITO_DISCIPLINAINTINERARIO_DISCIPLINA` (`idDisciplinaIntinerario`),
  ADD KEY `FK_PREREQUISITO_DISCIPLINAINTINERARIO_REQUISITO` (`idDisciplinaIntinerarioRequisito`);

--
-- Indexes for table `professor`
--
ALTER TABLE `professor`
  ADD PRIMARY KEY (`idProfessor`),
  ADD KEY `FK_PROFESSOR_PESSOA` (`idPessoa`),
  ADD KEY `FK_PROFESSOR_VINCULOSITUACAO` (`idVinculoSituacao`);

--
-- Indexes for table `professoresTurma`
--
ALTER TABLE `professoresTurma`
  ADD PRIMARY KEY (`idProfessor`,`idTurma`),
  ADD KEY `FK_PROFESSORESTURMA_TURMA` (`idTurma`);

--
-- Indexes for table `titulacao`
--
ALTER TABLE `titulacao`
  ADD PRIMARY KEY (`idTitulacao`);

--
-- Indexes for table `turma`
--
ALTER TABLE `turma`
  ADD PRIMARY KEY (`idTurma`),
  ADD KEY `FK_TURMA_DISCIPLINA` (`idDisciplina`),
  ADD KEY `FK_TURMA_TURMATIPO` (`idTurmaTipo`),
  ADD KEY `FK_TURMA_TURMASITUACAO` (`idTurmaSituacao`);

--
-- Indexes for table `turmaSituacao`
--
ALTER TABLE `turmaSituacao`
  ADD PRIMARY KEY (`idTurmaSituacao`);

--
-- Indexes for table `turmaTipo`
--
ALTER TABLE `turmaTipo`
  ADD PRIMARY KEY (`idTurmaTipo`);

--
-- Indexes for table `vinculoSituacao`
--
ALTER TABLE `vinculoSituacao`
  ADD PRIMARY KEY (`idVinculoSituacao`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aluno`
--
ALTER TABLE `aluno`
  MODIFY `idAluno` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `curso`
--
ALTER TABLE `curso`
  MODIFY `idCurso` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `disciplina`
--
ALTER TABLE `disciplina`
  MODIFY `idDisciplina` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `disciplinaIntinerario`
--
ALTER TABLE `disciplinaIntinerario`
  MODIFY `idDisciplinaIntinerario` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `historico`
--
ALTER TABLE `historico`
  MODIFY `idHistorico` int(19) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `intinerarioFormativo`
--
ALTER TABLE `intinerarioFormativo`
  MODIFY `idIntinerarioFormativo` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `matricula`
--
ALTER TABLE `matricula`
  MODIFY `idMatricula` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;
--
-- AUTO_INCREMENT for table `matriculaSituacao`
--
ALTER TABLE `matriculaSituacao`
  MODIFY `idMatriculaSituacao` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `perfil`
--
ALTER TABLE `perfil`
  MODIFY `idPerfil` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `periodoMatricula`
--
ALTER TABLE `periodoMatricula`
  MODIFY `idPeriodoMatricula` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `pessoa`
--
ALTER TABLE `pessoa`
  MODIFY `idPessoa` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `prerequisito`
--
ALTER TABLE `prerequisito`
  MODIFY `idPrerequisito` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `professor`
--
ALTER TABLE `professor`
  MODIFY `idProfessor` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `titulacao`
--
ALTER TABLE `titulacao`
  MODIFY `idTitulacao` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `turma`
--
ALTER TABLE `turma`
  MODIFY `idTurma` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `turmaSituacao`
--
ALTER TABLE `turmaSituacao`
  MODIFY `idTurmaSituacao` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `turmaTipo`
--
ALTER TABLE `turmaTipo`
  MODIFY `idTurmaTipo` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `vinculoSituacao`
--
ALTER TABLE `vinculoSituacao`
  MODIFY `idVinculoSituacao` int(19) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `aluno`
--
ALTER TABLE `aluno`
  ADD CONSTRAINT `FK_ALUNO_CURSO` FOREIGN KEY (`idCurso`) REFERENCES `curso` (`idCurso`),
  ADD CONSTRAINT `FK_ALUNO_INTINERARIOFORMATIVO` FOREIGN KEY (`idIntinerarioFormativo`) REFERENCES `intinerarioFormativo` (`idIntinerarioFormativo`),
  ADD CONSTRAINT `FK_ALUNO_PESSOA` FOREIGN KEY (`idPessoa`) REFERENCES `pessoa` (`idPessoa`),
  ADD CONSTRAINT `FK_ALUNO_VINCULOSITUACAO` FOREIGN KEY (`idVinculoSituacao`) REFERENCES `vinculoSituacao` (`idVinculoSituacao`);

--
-- Constraints for table `curso`
--
ALTER TABLE `curso`
  ADD CONSTRAINT `FK_CURSO_TITULACAO` FOREIGN KEY (`idTitulacao`) REFERENCES `titulacao` (`idTitulacao`);

--
-- Constraints for table `disciplinaIntinerario`
--
ALTER TABLE `disciplinaIntinerario`
  ADD CONSTRAINT `FK_DISCIPLINAINTINERARIO_DISCIPLINA` FOREIGN KEY (`idDisciplina`) REFERENCES `disciplina` (`idDisciplina`),
  ADD CONSTRAINT `FK_DISCIPLINAINTINERARIO_INTINERARIO` FOREIGN KEY (`idIntinerarioFormativo`) REFERENCES `intinerarioFormativo` (`idIntinerarioFormativo`);

--
-- Constraints for table `historico`
--
ALTER TABLE `historico`
  ADD CONSTRAINT `FK_HISTORICO_ALUNO` FOREIGN KEY (`idAluno`) REFERENCES `aluno` (`idAluno`),
  ADD CONSTRAINT `FK_HISTORICO_DISCIPLINA` FOREIGN KEY (`idDisciplina`) REFERENCES `disciplina` (`idDisciplina`);

--
-- Constraints for table `intinerarioFormativo`
--
ALTER TABLE `intinerarioFormativo`
  ADD CONSTRAINT `FK_INTINERARIO_CURSO` FOREIGN KEY (`idCurso`) REFERENCES `curso` (`idCurso`);

--
-- Constraints for table `matricula`
--
ALTER TABLE `matricula`
  ADD CONSTRAINT `FK_MATRICULA_ALUNO` FOREIGN KEY (`idAluno`) REFERENCES `aluno` (`idAluno`),
  ADD CONSTRAINT `FK_MATRICULA_MATRICULASITUACAO` FOREIGN KEY (`idMatriculaSituacao`) REFERENCES `matriculaSituacao` (`idMatriculaSituacao`),
  ADD CONSTRAINT `FK_MATRICULA_TURMA` FOREIGN KEY (`idTurma`) REFERENCES `turma` (`idTurma`);

--
-- Constraints for table `periodoMatricula`
--
ALTER TABLE `periodoMatricula`
  ADD CONSTRAINT `FK_PARIODOMATRICULA_PESSOA` FOREIGN KEY (`idPessoa`) REFERENCES `pessoa` (`idPessoa`);

--
-- Constraints for table `pessoaPerfil`
--
ALTER TABLE `pessoaPerfil`
  ADD CONSTRAINT `FK_PESSOAPERFIL_PERFIL` FOREIGN KEY (`idPerfil`) REFERENCES `perfil` (`idPerfil`),
  ADD CONSTRAINT `FK_PESSOAPERFIL_PESSOA` FOREIGN KEY (`idPessoa`) REFERENCES `pessoa` (`idPessoa`);

--
-- Constraints for table `prerequisito`
--
ALTER TABLE `prerequisito`
  ADD CONSTRAINT `FK_PREREQUISITO_DISCIPLINAINTINERARIO_DISCIPLINA` FOREIGN KEY (`idDisciplinaIntinerario`) REFERENCES `disciplinaIntinerario` (`idDisciplinaIntinerario`),
  ADD CONSTRAINT `FK_PREREQUISITO_DISCIPLINAINTINERARIO_REQUISITO` FOREIGN KEY (`idDisciplinaIntinerarioRequisito`) REFERENCES `disciplinaIntinerario` (`idDisciplinaIntinerario`);

--
-- Constraints for table `professor`
--
ALTER TABLE `professor`
  ADD CONSTRAINT `FK_PROFESSOR_PESSOA` FOREIGN KEY (`idPessoa`) REFERENCES `pessoa` (`idPessoa`),
  ADD CONSTRAINT `FK_PROFESSOR_VINCULOSITUACAO` FOREIGN KEY (`idVinculoSituacao`) REFERENCES `vinculoSituacao` (`idVinculoSituacao`);

--
-- Constraints for table `professoresTurma`
--
ALTER TABLE `professoresTurma`
  ADD CONSTRAINT `FK_PROFESSORESTURMA_PROFESSOR` FOREIGN KEY (`idProfessor`) REFERENCES `professor` (`idProfessor`),
  ADD CONSTRAINT `FK_PROFESSORESTURMA_TURMA` FOREIGN KEY (`idTurma`) REFERENCES `turma` (`idTurma`);

--
-- Constraints for table `turma`
--
ALTER TABLE `turma`
  ADD CONSTRAINT `FK_TURMA_DISCIPLINA` FOREIGN KEY (`idDisciplina`) REFERENCES `disciplina` (`idDisciplina`),
  ADD CONSTRAINT `FK_TURMA_TURMASITUACAO` FOREIGN KEY (`idTurmaSituacao`) REFERENCES `turmaSituacao` (`idTurmaSituacao`),
  ADD CONSTRAINT `FK_TURMA_TURMATIPO` FOREIGN KEY (`idTurmaTipo`) REFERENCES `turmaTipo` (`idTurmaTipo`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
