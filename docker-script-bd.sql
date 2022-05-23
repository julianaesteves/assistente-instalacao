USE onhome;

CREATE TABLE IF NOT EXISTS Licenca (
	idLicenca INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(45),
	quantComputadores INT,
	dataAquisicao DATETIME,
	valor DOUBLE
);

CREATE TABLE IF NOT EXISTS Empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT, 
	nomeFantasia VARCHAR(100),
	cnpj CHAR(14),
	fkLicenca INT
);

CREATE TABLE IF NOT EXISTS Endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
	cep CHAR(8),
	logadouro VARCHAR(100),
	numero INT,
	bairro VARCHAR(45),
	complemento VARCHAR(30),
	estado VARCHAR(100),
	cidade VARCHAR(100),
	fkEmpresa INT
);

CREATE TABLE IF NOT EXISTS Contatos (
	idContatos INT PRIMARY KEY AUTO_INCREMENT,
	telefoneEmpresa VARCHAR(11),
	emailEmpresa VARCHAR(45),
	fkEmpresa INT
);

CREATE TABLE IF NOT EXISTS Especialidade (
	idEspecialidade INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
	nomeUsuario VARCHAR(50),
	emailUser VARCHAR(50),
	senhaUser VARCHAR(50),
	fkEmpresa INT,
	fkPermissao INT,
	fkEspecialidade INT
);

CREATE TABLE IF NOT EXISTS Permissao (
	idPermissao INT PRIMARY KEY AUTO_INCREMENT,
	cargo VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS Periodo (
	idPeriodo INT PRIMARY KEY AUTO_INCREMENT,
	periodo VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS Computadores (
	idComputador INT PRIMARY KEY AUTO_INCREMENT,
    ipComputador VARCHAR(30),
	hostName VARCHAR(30),
	sistemaOperacional VARCHAR(20),
	modeloProcessador VARCHAR(50),
	idProcessador VARCHAR(30),
	tamanhoDisco DOUBLE,
	tamanhoDiscoSecundario DOUBLE,
	tamanhoRam DOUBLE,
	fkUsuario INT
);

CREATE TABLE IF NOT EXISTS Monitoramento (
	idMonitoramento INT PRIMARY KEY AUTO_INCREMENT,
	processadorLogico INT,
	processadorFisico INT,
	usandoCpu DOUBLE,
	usandoDisco DOUBLE,
	usandoRam DOUBLE,
	dataHoraCaptura VARCHAR(19),
	tempoLigada VARCHAR(15),
	fkComputador INT
);

CREATE TABLE IF NOT EXISTS Processo (
	idProcesso INT PRIMARY KEY AUTO_INCREMENT,
	nomeProcesso VARCHAR(100),
	usoCpu DOUBLE,
	usoMemoria DOUBLE,
	usoGpu DOUBLE,
	dataCaptura VARCHAR(19),
	fkComputador INT
);

CREATE TABLE IF NOT EXISTS Gamificacao (
	idGamificacao INT PRIMARY KEY AUTO_INCREMENT,
	qtdPontos INT,
	fkUsuario INT
);


INSERT INTO Usuario(nomeUsuario, emailUser, senhaUser) VALUES ('adminOnHome', 'admin@onhome.com', 'admin@admin');
