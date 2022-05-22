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

	if [ "$( ls -l | grep 'docker-script-bd.sql' | wc -l )" -eq "1" ]; then
		rm docker-script-bd.sql

	fi

	if [ "$( ls -l | grep 'dockerfile' | wc -l )" -eq "1" ]; then
		rm dockerfile

	fi
    
if [ "$( ls -l |  grep $jar_onhome | wc -l)" -eq "0" ]; then

    echo "$(tput setaf 10)[OnHome]: Baixando o programa OnHome..."

        wget $baixar_jar 1> /dev/null 2> /dev/stdout

        iniciar_sistema


else

    sleep 2
        
    iniciar_sistema
  

    if [ $? -eq 1 ]; then 

    echo "$(tput setaf 10)[OnHome]: Erro ao baixar o programa. "

    sleep 1 

    exit 0 

    fi


fi    

}


 # Cria o container Docker

criar_container() {

	if [ "$(sudo docker ps -aqf 'name=ConteinerBD' | wc -l)" -eq "0" ]; then
		echo ""
		echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7)Finalizando instalação do docker..."
		sudo docker run -d -p 3306:3306 --name ConteinerBD -e "MYSQL_ROOT_PASSWORD=urubu100" onhome:1.0  1> /dev/null 2> /dev/stdout		
	
	fi

     instalando_onhome
}

# Cria uma imagem mysql docker modificada com o banco inserido
gerar_imagem_personalizada() { 

	if [ "$( ls -l | grep 'docker-script-bd.sql' | wc -l )" -eq "0" ]; then
		wget $script_bd 1> /dev/null 2> /dev/stdout

	fi

	if [ "$( ls -l | grep 'dockerfile' | wc -l )" -eq "0" ]; then
echo "
FROM mysql:5.7

ENV MYSQL_DATABASE onhome

COPY docker-script-bd.sql /docker-entrypoint-initdb.d/
" > dockerfile 

	fi

	if [ "$(sudo docker images | grep 'onhome' | wc -l)" -eq "0" ]; then
		sudo docker build -t onhome:1.0 . 1> /dev/null 2> /dev/stdout

	fi

	criar_container

}

# Baixa a imagem SQL do docker
instalar_sql_docker() { 

	if [ "$(sudo docker images | grep 'mysql' | wc -l)" -eq "0" ]; then
	echo ""
	echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7) Criando imagem docker..."
		sudo docker pull mysql:5.7 1> /dev/null 2> /dev/stdout
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
