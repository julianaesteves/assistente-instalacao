#!/bin/bash

# Variáveis
jar_onhome='onhome-api-servidor.jar'
baixar_jar='https://github.com/matheusferreira079/jar-banco/raw/main/onhome-api-servidor.jar'
script_bd='https://github.com/julianaesteves/script-ec2/raw/main/docker-script-bd.sql'

instalando_onhome() {
    echo "entrando no terminal do container"
    sudo docker exec -it OnHome bash
    cd app
    echo "executando o app"
    java -jar app.jar

}

 # Cria o container Docker

criar_container() {

	if [ "$(sudo docker ps -aqf 'name=OnHome' | wc -l)" -eq "0" ]; then
		echo ""
		echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7)Criando o container..."
		sudo docker run -d -p 8080:8080 --name OnHome onhomeapi/java  1> /dev/null 2> /dev/stdout
        echo "Executando o app"
        
	
	fi

     instalando_onhome
}

# Cria uma imagem mysql docker modificada com o banco inserido
gerar_imagem_personalizada() { 

	if [ "$(sudo docker images | grep 'onhome' | wc -l)" -eq "0" ]; then
		sudo docker build . --tag onhomeapi/java . 1> /dev/null 2> /dev/stdout

	fi

	criar_container

}

# Baixa a imagem SQL do docker
clonar_repositorio() { 

	if [ "$(ls | grep 'api-monitoramento' | wc -l)" -eq "0" ]; then
	echo ""
	echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7) Clonando a aplicação..."
		git clone https://github.com/matheusferreira079/api-monitoramento-hardware-onhome.git 1> /dev/null 2> /dev/stdout
        ls
        cd api-monitoramento-hardware_sem_Swing
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
		
		clonar_repositorio


}

# Função responsável pela instalação do docker
instalar_docker() {

	if [ "$(dpkg --get-selections | grep 'docker.io' | wc -l)" -eq "0" ]; then
		echo ""
		echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7) Atualizando as dependências..."
		sudo apt update -y  1> /dev/null 2> /dev/stdout 
        echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7)--------- Instalando o docker ------"

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
                    echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) -- Preparando... -- "
                    instalar_docker
else
		echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) : Todos os requisitos estão de acordo, prosseguindo com a instalação..."
         instalar_docker 
                   
                    
fi

}

verificar_java
