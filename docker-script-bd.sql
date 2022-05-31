USE onhome;

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
