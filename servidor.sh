#!/bin/bash

# Variáveis
jar_onhome='onhome-api-servidor.jar'
baixar_jar='https://github.com/matheusferreira079/jar-banco/raw/main/onhome-api-servidor.jar'
script_bd='https://github.com/julianaesteves/script-ec2/raw/main/docker-script-bd.sql'


# Função responsavel por iniciar a API
iniciar_sistema() {

echo "$(tput setaf 10)[OnHome]: Sistema pronto. Deseja iniciar? s/n"
read confirm

if [ \"$confirm\" == \"s\" ]; then
echo "$(tput setaf 10)[OnHome]: Inicializando, por favor, aguarde..."
java -jar $jar_onhome 1> /dev/null 2> /dev/stdout

else
    echo ""
    echo "$(tput setaf 10)[OnHome]: Inicialização cancelada."
    sleep 1
    echo ""

    echo "$(tput setaf 10)[OnHome]: Para outra tentativa de instalação reinicie o programa."
    sleep 1
    echo ""

    echo "$(tput setaf 10)[OnHome]: Encerrando instalação..."

    exit 0

    fi

}


# Função que instala o software da OnHome
instalando_onhome() { 

 echo "Iniciando a aplicação OnHome"
    pwd
    sudo docker exec -w /app onhomeJava java -jar application.jar



}


 # Cria o container Docker

gerar_imagem_container_java() {

	cd ..
	cd Arquitetura_B
	sudo docker build . --tag onhome-application
	sudo docker run -d -p 8080:8080 --name onhomeJava onhome-application

     instalando_onhome
}

# Cria uma imagem mysql docker modificada com o banco inserido
gerar_imagem_container_sql() { 

	sudo docker build . --tag onhome-mysql
	sudo docker run -d -p 3306:3306 onhome-mysql

	gerar_imagem_container_java

}

# Baixa a imagem SQL do docker
clonar_repositorio() { 

	if [ "$(ls | grep 'ac3-docker' | wc -l)" -eq "0" ]; then
	echo ""
	echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7) Clonando a aplicação..."
		git clone https://github.com/matheusferreira079/ac3-docker.git
        ls
		cd ac3-docker
		cd mysql
		pwd
		gerar_imagem_container_sql

	else
		gerar_imagem_container_sql

	fi

}

# Função responsável por ativar o docker
ligar_docker(){

if [ "$(sudo service docker status | head -2 | tail -1 | awk '{print $4}' | sed 's/\;//g')" != "enabled" ]; 
    then 
		sudo systemctl enable docker

	fi

	if [ "$(sudo systemctl is-active docker)" != "active" ]; then
		sudo systemctl start docker

    fi
		
		clonar_repositorio

}


# Função responsável pela instalação do docker
instalar_docker() {

	if [ "$(dpkg --get-selections | grep 'docker.io' | wc -l)" -eq "0" ]; then
		echo ""
		echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7) Realizando a instalação do Docker..."
		sudo apt update -y  1> /dev/null 2> /dev/stdout 
		sudo apt install docker.io -y 1> /dev/null 2> /dev/stdout
		ligar_docker

	else
		ligar_docker
	
	fi
}




# Função responsável por verificar se o java está na máquina

verificar_java() {

echo  "$(tput setaf 10)[Onhome]:$(tput setaf 7) ---------------------------  Olá cliente OnHome!! ---------------------------"
echo  "$(tput setaf 10)[Onhome]:$(tput setaf 7) Estamos realizando uma verificação de requisitos obrigatórios para o funcionamento correto do sistema, um momento..."

sleep 3


if [ "$(dpkg --get-selections | grep 'default-jre' | wc -l)" -eq "0" ];
	then
		echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) : Você não tem a versão do Java necessária no seu computador. Instalação necessária para execução do programa. "
	
					echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) Realizando instalação do Java(11.0.10 LTS)..."
					sudo apt install default-jre ; apt install openjdk-11-jre-headless; y
					clear
					echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) Instalado com sucesso!"
                    echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) -- Inicializando instalação do docker -- "
                    instalar_docker
else
		echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) : Todos os requisitos estão de acordo, prosseguindo com a instalação..."
         instalar_docker 
                   
                    
fi

}

verificar_java
