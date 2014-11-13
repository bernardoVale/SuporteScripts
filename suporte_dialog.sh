#!/bin/bash
#-------------------------------------------------------------
#                   Menu Suporte - Versão Dialog
#
#       Autor: Bernardo S E Vale
#       Data Inicio:  12/11/2014
#       Data Release: 12/11/2014
#       email: bernardo.vale@lb2.com.br
#       Versão: v1.0
#       LB2 Consultoria - Leading Business 2 the Next Level!
#-------------------------------------------------------------
DIALOG="/usr/bin/dialog"
export LC_CTYPE="pt_BR.UTF-8"
LOG_FILE=/home/suporte/log_suporte.txt
data=`date`

pauseShell(){
	    echo $data >> $LOG_FILE 2>&1
        echo "Pressione qualquer tecla para continuar..." >> $LOG_FILE 2>&1
}

aquiTransa(){
    rm -rf ${LOG_FILE} >> /dev/null 2>&1
    touch ${LOG_FILE}
    ${SCRIPT} >> ${LOG_FILE} 2>&1 &
}
while true
do
    RESPOSTA=$(${DIALOG} --stdout --title 'OPÇÕES' --menu 'Escolha uma das ações abaixo' 0 0 0 \
       Oracle\ Status    'Verifica o status das instancias de Oracle DB' \
       Iniciar\ Oracle    'Inicia todos os bancos e listeners do ambiente' \
       Parar\ Oracle    'Desliga todos os bancos e listeners do ambiente' \
       Listener\ Status    'Verifica o status de todos os listeners' \
       Parar\ Listener    'Desliga todos os listeners do ambiente' \
       Iniciar\ Listener    'Desliga todos os listeners do ambiente' )
    if [ "$RESPOSTA" == "Oracle Status" ]; then
        SCRIPT="/home/suporte/oracle_status.sh"
    elif [ "$RESPOSTA" == "Iniciar Oracle" ]; then
        SCRIPT="/home/suporte/oracle.sh start"
    elif [ "$RESPOSTA" == "Parar Oracle" ]; then
        SCRIPT="/home/suporte/oracle.sh stop"
    elif [ "$RESPOSTA" == "Parar Listener" ]; then
        SCRIPT="/home/suporte/oracle_lsnrctl.sh stop"
    elif [ "$RESPOSTA" == "Iniciar Listener" ]; then
        SCRIPT="/home/suporte/oracle_lsnrctl.sh start"
    elif [ "$RESPOSTA" == "Listener Status" ]; then
        SCRIPT="/home/suporte/oracle_lsnrctl.sh status"
    else
        exit 0
    fi
    #aquiTransa
    rm -rf ${LOG_FILE} >> /dev/null 2>&1
    touch ${LOG_FILE}
    ${SCRIPT} >> ${LOG_FILE} 2>&1 &
    (dialog --no-kill --title 'Verificando' --tailbox $LOG_FILE 80 120 )
done
exit
