#!/bin/bash

pauseShell(){
	echo $data
        echo "Pressione qualquer tecla para continuar..."
        read
}

oracleStatus(){
	echo ""
	echo $data
	echo "Oracle Database Status: "
	/home/suporte/oracle_status.sh
	echo ""
}

listenerStatus(){
	echo ""
	echo $data
	echo "Listener Status: "
	/home/suporte/oracle_listener_status.sh
	echo ""
}

lsnrctlStatus(){
	/home/suporte/oracle_lsnrctl.sh status
	echo ""
}

startOracle(){
	echo ""
	echo $data
	echo "Iniciando Oracle Database"
	sudo /home/suporte/oracle.sh start
	echo ""
	echo $data
	echo "Pressione qualquer tecla para continuar..."
	echo read
}

stopOracle(){
        echo ""
	echo $data
        echo "Desligando Oracle Database - MODO IMMEDIATE"
        sudo /home/suporte/oracle.sh "stop"
        echo ""
	echo $data
	echo "Pressione qualquer tecla para continuar..."
	echo read
}

startListener(){
	/home/suporte/oracle_lsnrctl.sh start
        echo ""
}

stopListener(){
	/home/suporte/oracle_lsnrctl.sh stop
        echo ""
}

godmode(){
	echo -e "\e[1m\e[31mGODMODE ON\e[0m"
	sleep 2
	/home/suporte/godmode.sh
}

while true
do
	data=`date`
	who=`who am i`
	LOG_FILE=/home/suporte/log_suporte.txt
	clear
	echo "################################################"
	echo -e "################ \e[103m\e[90m\e[1mLB2 CONSULTORIA\e[0m ###############"
	echo "################################################"
	echo ""
	echo "Acesso:" >> $LOG_FILE
	echo "Data:"
	echo $data
	echo ""
	echo $data >> $LOG_FILE
	echo "Usuario:"
	echo $who
	echo ""
	echo $who >> $LOG_FILE
	echo ""
	cat banner.txt
	oracleStatus
	listenerStatus
	echo "################################################"
	echo "#################### OPCOES ####################"
	echo "################################################"
	echo ""
	echo "1 - Exibir status do Oracle Database"
	echo "2 - Exibir status do Listener"
	echo "3 - Iniciar Oracle Database"
	echo "4 - Desligar Oracle Database"
	echo "5 - Iniciar o Listener"
	echo "6 - Parar o Listener"
	echo "7 - Sair"
	echo ""
	echo -ne "\n: "
	read op
	clear
	case $op in
		1) oracleStatus | tee -a $LOG_FILE; pauseShell
		;;
		2) lsnrctlStatus | tee -a $LOG_FILE; pauseShell
		;;
		3) startOracle | tee -a $LOG_FILE
		;;
		4) stopOracle | tee -a $LOG_FILE
		;;
		5) startListener | tee -a $LOG_FILE; pauseShell
		;;
		6) stopListener | tee -a $LOG_FILE; pauseShell
		;;
		7) exit
		;;
		god) godmode
		;;

esac
done
exit
case $RESPOSTA in

    "Oracle Status")
        SCRIPT="/home/suporte/oracle_status.sh";;
    "Iniciar Oracle")
        SCRIPT="/home/suporte/oracle.sh start";;
    "Parar Oracle")
        SCRIPT="/home/suporte/oracle.sh stop";;
    *)
        exit 0
    esac