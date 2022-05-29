#!/bin/bash

instalando_onhome() {
    echo "Iniciando a aplicação OnHome"
    pwd
    sudo docker exec -w /app OnHome java -jar app.jar
   

}

 # Cria o container Docker

criar_container() {

	if [ "$(sudo docker ps -aqf 'name=OnHome' | wc -l)" -eq "0" ]; then
		echo ""
		echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7)Criando o container..."
		sudo docker run -d -p 8080:8080 --name OnHome onhomeapi/java
        echo "Executando o app"
        
	
	fi

     instalando_onhome
}

# Cria uma imagem docker modificada
gerar_imagem_personalizada() { 


	#if [ "$(sudo docker images | grep 'onhome' | wc -l)" -eq "0" ]; then
	echo -e "$(tput setaf 4)[OnHome]:$(tput setaf 7) Gerando a imagem personalizada da aplicação"
		sudo docker build . --tag onhomeapi/java

        sudo docker images

	#fi

	criar_container

}

# Clona o repositório da API do github
clonar_repositorio() { 

	if [ "$(ls | grep 'api-monitoramento' | wc -l)" -eq "0" ]; then
	echo "==============================================================================="

	echo -e "$(tput setaf 10)[OnHome]:$(tput setaf 7) Inserindo a aplicação OnHome na máquina"
		git clone https://github.com/matheusferreira079/api-monitoramento-hardware-onhome.git
        ls
	cd api-monitoramento-hardware-onhome
    pwd
    cd api-onhome-refactor
     pwd
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
		echo "==============================================================================="
		echo -e "$(tput setaf 4)[OnHome]:$(tput setaf 7) Vamos fazer uma atualização das dependências do seu computador, por favor aguarde."
		echo "==============================================================================="

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
 echo "$(tput setaf 4)Seja bem-vindo(a) ao assistente de instalação da OnhHome!"
 echo "==============================================================================="
echo  "$(tput setaf 4)[Onhome]:$(tput setaf 7) Estamos realizando uma verificação de requisitos obrigatórios para o funcionamento correto do sistema, um momento..."

sleep 3


if [ "$(dpkg --get-selections | grep 'default-jre' | wc -l)" -eq "0" ];
	then
		echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) : Você não tem a versão do Java necessária no seu computador. Instalação necessária para execução do programa. "
	
					echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) Realizando instalação do Java(11.0.10 LTS)..."
					sudo apt install default-jre ; apt install openjdk-11-jre-headless; -y
 					echo "==============================================================================="
					echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) O Java foi instalado com sucesso!"
					echo "==============================================================================="
					clear
                    instalar_docker
else
		echo "$(tput setaf 4)[Onhome]:$(tput setaf 7) : Você já tem a versão necessária do Java no seu computador, prosseguindo com a instalação..."
         instalar_docker 
                   
                    
fi

}

verificar_java
