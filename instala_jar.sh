#!/bin/bash

# Variáveis
jar_onhome='onhome-api-monitoramento-Banco_Azure.jar'
baixar_jar='https://github.com/matheusferreira079/jar-banco/raw/main/onhome-api-monitoramento-Banco_Azure.jar'

# Função responsavel por iniciar a API
iniciar_sistema() {

echo "$(tput setaf 10)[OnHome]: Sistema pronto. Deseja iniciar? s/n"
read confirm

if [ \"$confirm\" == \"s\" ]; then
echo "$(tput setaf 10)[OnHome]: Inicializando, por favor, aguarde..."
java -jar $jar_onhome 1> /dev/null 2> /dev/stdout

else
    echo ""
    echo "$(tput setaf 10)[OnHome]: Inicializaçã cancelada."
    sleep 1
    echo ""

    echo "$(tput setaf 10)[OnHome]: Para outra tentativa de instalação inicie o programa novamente."
    sleep 1
    echo ""

    echo "$(tput setaf 10)[OnHome]: Encerrando instalação..."

    exit 0

    fi

}


# Função que instala o software da OnHome
instalando_onhome() { 
    
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

# Função responsável por verificar se o java está na máquina

verificar_java() {

echo  "$(tput setaf 10)[Onhome]:$(tput setaf 7) ---------------------------  Olá cliente OnHome!! ---------------------------"
echo  "$(tput setaf 10)[Onhome]:$(tput setaf 7) Estamos realizando uma verificação de requisitos obrigatórios para o funcionamento correto do sistema, um momento..."

sleep 3


if [ "$(dpkg --get-selections | grep 'default-jre' | wc -l)" -eq "0" ];
	then
		echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) : Você não tem a versão do Java necessária no seu computador. Instalação necessária para execução do programa. "
	
					echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) Realizando instalação do Java(11.0.10 LTS)..."
					sudo apt install default-jre ; apt install openjdk-11-jre-headless; -y
					clear
					echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) Instalado com sucesso!"
                    echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) -- Inicializando instalação do sistema OnHome -- "
                    instalando_onhome
else
		echo "$(tput setaf 10)[Onhome]:$(tput setaf 7) : Você ja tem o Java instalado por favor aguardo enquanto verificamos a versão"
                    
                    
fi

}

verificar_java
