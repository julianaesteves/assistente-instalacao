#!/bin/bash

# Variáveis
jar_onhome='api-onhome-version-final.jar'
baixar_jar='https://github.com/matheusferreira079/jar-banco/raw/main/api-onhome-version-final.jar'
script_bd='https://github.com/julianaesteves/script-ec2/raw/main/docker-script-bd.sql'


# Função responsavel por iniciar a API
iniciar_sistema() {
echo "==============================================================================="
echo "$(tput setaf 10)[OnHome]: O sistema está pronto para ser executado. Por favor, confirme a inicialização: deseja começar? s/n"
echo "==============================================================================="
read confirm

if [ \"$confirm\" == \"s\" ]; then

ls

sleep 1

echo "$(tput setaf 10)[OnHome]: Ok, o programa abrirá em instantes! :)"

sleep 1

java -jar api-onhome-version-final.jar

else
    echo ""
    echo "$(tput setaf 10)[OnHome]: Inicialização cancelada."
    sleep 1
    echo ""

    echo "$(tput setaf 10)[OnHome]: Para outra tentativa de instalação reinicie o programa."
    sleep 1
    echo ""
	echo "==============================================================================="
    echo "$(tput setaf 10)[OnHome]: Encerrando instalação..."
	echo "==============================================================================="
    exit 0

    fi

}


# Função que instala o software da OnHome
instalando_onhome() { 

	if [ "$( ls -l | grep 'docker-script-bd.sql' | wc -l )" -eq "1" ]; then
		rm docker-script-bd.sql

	fi

	if [ "$( ls -l | grep 'dockerfile' | wc -l )" -eq "1" ]; then
		rm dockerfile

	fi
    
if [ "$( ls -l |  grep $jar_onhome | wc -l)" -eq "0" ]; then
	echo "==============================================================================="
    echo "$(tput setaf 10)[OnHome]: Baixando o programa OnHome..."
	echo "==============================================================================="
        wget $baixar_jar

        iniciar_sistema


else

    sleep 2
        
    iniciar_sistema
  

    if [ $? -eq 1 ]; then 

	echo "==============================================================================="
    echo "$(tput setaf 4)[OnHome]: Erro ao baixar o programa. Por favor, tente novamente! "
	echo "==============================================================================="

    sleep 1 

    exit 0 

    fi


fi    

}


 # Cria o container Docker

criar_container() {

	if [ "$(sudo docker ps -aqf 'name=OnHome' | wc -l)" -eq "0" ]; then
		echo "==============================================================================="
		echo -e "$(tput setaf 4)[OnHome]:$(tput setaf 7)Executando o docker com a imagem da aplicação OnHome"
		echo "==============================================================================="
		sudo docker run -d -p 3306:3306 --name OnHome -e "MYSQL_ROOT_PASSWORD=2ads@grupo10" onhome-mysql
	
	fi

     instalando_onhome
}

# Cria uma imagem mysql docker modificada com o banco inserido
gerar_imagem_personalizada() { 



	if [ "$( ls -l | grep 'docker-script-bd.sql' | wc -l )" -eq "0" ]; then
		echo "==============================================================================="
		echo "$(tput setaf 4)[OnHome]:$(tput setaf 7) Realizando o download do script SQL do banco de dados local"
		echo "==============================================================================="
		wget $script_bd

	fi

	if [ "$( ls -l | grep 'dockerfile' | wc -l )" -eq "0" ]; then
echo "
FROM mysql:5.7

ENV MYSQL_DATABASE onhome

COPY docker-script-bd.sql /docker-entrypoint-initdb.d/
" > dockerfile 

	fi

	if [ "$(sudo docker images | grep 'onhome' | wc -l)" -eq "0" ]; then
		echo "==============================================================================="
		echo "$(tput setaf 4)[OnHome]:$(tput setaf 7) Gerando imagem personalizada com base nos dados da Dockerfile"
		echo "==============================================================================="
		sudo docker build . --tag onhome-mysql

	fi

	criar_container

}

# Baixa a imagem SQL do docker
instalar_sql_docker() { 

	if [ "$(sudo docker images | grep 'mysql' | wc -l)" -eq "0" ]; then
	echo "==============================================================================="
	echo -e "$(tput setaf 4)[OnHome]:$(tput setaf 7) Baixando a imagem docker do MySQL"
	echo "==============================================================================="
		sudo docker pull mysql:5.7 
		gerar_imagem_personalizada

	else
		gerar_imagem_personalizada

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
		
		instalar_sql_docker


}

# Função responsável pela instalação do docker
instalar_docker() {
		echo "==============================================================================="
		echo -e "$(tput setaf 4)[OnHome]:$(tput setaf 7) Vamos fazer uma atualização das dependências do seu computador, por favor aguarde."
		echo "==============================================================================="


	if [ "$(dpkg --get-selections | grep 'docker.io' | wc -l)" -eq "0" ]; then
		
		sudo apt update -y  1> /dev/null 2> /dev/stdout 
		echo "==============================================================================="

        echo -e "$(tput setaf 4)[OnHome]:$(tput setaf 7)Dependências instaladas com sucesso. Prosseguindo para a instalação do Docker..."
		sudo apt install docker.io -y 1> /dev/null 2> /dev/stdout
		ligar_docker

	else
		ligar_docker
	
	fi
}




# Função responsável por verificar se o java está na máquina

verificar_java() {

	echo "$(tput setaf 4)Seja bem-vindo(a) ao assistente de instalação da OnHome!"
	echo "==============================================================================="
	echo  "$(tput setaf 4)[Onhome]:$(tput setaf 7) Estamos realizando uma verificação de requisitos obrigatórios para o funcionamento correto do sistema, um momento..."


sleep 3


if [ "$(dpkg --get-selections | grep 'default-jre' | wc -l)" -eq "0" ];
	then
		echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) : Você não tem a versão do Java necessária no seu computador. Instalação necessária para execução do programa. "
	
					echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) Realizando instalação do Java(11.0.10 LTS)..."
					sudo apt install default-jre ; apt install openjdk-11-jre-headless; y
					clear
					echo "==============================================================================="
					echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) O Java foi instalado com sucesso!"
					echo "==============================================================================="
                    instalar_docker
else
		echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) : Você já tem a versão necessária do Java no seu computador, prosseguindo com a instalação..."
         instalar_docker 
                   
                    
fi

}

verificar_java
