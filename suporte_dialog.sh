#!/bin/bash
#-------------------------------------------------------------
#                   Menu Suporte - Versão Dialog
#
#       Autor: Bernardo S E Vale
#       Data Inicio:  12/11/2014
#       Data Release: 14/11/2014
#       email: bernardo.vale@lb2.com.br
#       Versão: v1.0
#       LB2 Consultoria - Leading Business 2 the Next Level!
#
#           Documentação das modificações
#
#   Autor: xxx
#   Data: DD/MM/YYYY
#   Motivo:
#-------------------------------------------------------------

#-----------------------------------------------------------
#       DECLARAÇÃO DE VARIÁVEIS NECESSÁRIAS
#
#   Atenção ao LC_CTYPE, necessário para bom funcionamento
#   da acentuação
#
#   OBS: Favor verificar o caminho do DIALOG no seu SO
#------------------------------------------------------------
DIALOG="/usr/bin/dialog"
export LC_CTYPE="pt_BR.UTF-8"
LOG_FILE=/home/suporte/log_suporte.txt
data=`date`
#############################################################
#-----------------------------------------------------------
#               UTILITÁRIOS DO DIALOG
#
#   São declaradas aqui funções de configuração do DIALOG.
#------------------------------------------------------------
backtitle(){
    echo "LB2 - Leading Business to the Next Level"
}
cabecalho(){
    echo "             Servidor: LB2-Dev12c \n \n \n
                                RESPONSABILIDADES \n \n \n
    Oracle Database: Oracle 12c - Container Database (cdbdev) \n
    Oracle Database(pdbhd): Banco de desenvolvimento do Helpdesk \n
    Oracle Database(pdbsp): Banco de desenvolvimento do Sales Collaboration"
}
define_option(){
    echo "Oracle Status"
}

#############################################################
#-----------------------------------------------------------
#           DECLARAÇÃO DOS NOMES NO MENU
#
#   Função para definir qual script será executado
#
# OBS: O Nome declarado no menu deve ser comparado nesse IF
#       para definir qual script será chamado
#------------------------------------------------------------
choose_script(){
    if [ "$1" == "Oracle Status" ]; then
        SCRIPT=$(oracle_status)
    elif [ "$1" == "Iniciar Oracle" ]; then
        SCRIPT=$(oracle_start)
    elif [ "$1" == "Parar Oracle" ]; then
        SCRIPT=$(oracle_stop)
    elif [ "$1" == "Parar Listener" ]; then
        SCRIPT=$(listener_stop)
    elif [ "$1" == "Iniciar Listener" ]; then
        SCRIPT=$(listener_start)
    elif [ "$1" == "Listener Status" ]; then
        SCRIPT=$(listener_status)
    else
        exit 0
    fi
    echo ${SCRIPT}
}
############################################################
#-----------------------------------------------------------
#       DEFINIÇÕES DE TODOS OS SCRIPTS DO MENU
#
#   Siga o padrão echo "/path/to/script/script.sh variaveis"
#------------------------------------------------------------
oracle_status(){
    echo "/home/suporte/oracle_status.sh"
}
oracle_start(){
    echo "/home/suporte/oracle.sh start"
}
oracle_stop(){
    echo "/home/suporte/oracle.sh stop"
}
listener_status(){
    echo "/home/suporte/oracle_lsnrctl.sh status"
}
listener_start(){
    echo "/home/suporte/oracle_lsnrctl.sh start"
}
listener_stop(){
    echo "/home/suporte/oracle_lsnrctl.sh stop"
}
################################################################
#-----------------------------------------------------------
#               REBUILD LOG
#
#   Método necessário para eliminar o lixo do LOG_FILE
#   O segundo dialog nada mais é que um tail -f no $LOG_FILE
#   por isso é necessário esse rebuild.
#------------------------------------------------------------
rebuild_log(){
    rm -rf ${LOG_FILE} >> /dev/null 2>&1
    touch ${LOG_FILE}
}
#############################################################
while true
do
    CABECALHO=$(cabecalho)
    #OPTIONS=$(define_option)
    RESPOSTA=$(${DIALOG} --stdout --no-collapse --backtitle 'LB2 - Leading Business to the Next Level' \
    --title 'OPÇÕES' --menu "$CABECALHO" 0 0 0 \
       "$(define_option)"    'Verifica o status das instancias de Oracle DB' \
       Iniciar\ Oracle    'Inicia todos os bancos e listeners do ambiente' \
       Parar\ Oracle    'Desliga todos os bancos e listeners do ambiente' \
       Listener\ Status    'Verifica o status de todos os listeners' \
       Parar\ Listener    'Desliga todos os listeners do ambiente' \
       Iniciar\ Listener    'Desliga todos os listeners do ambiente' )
    SCRIPT=$(choose_script "$RESPOSTA")
    rebuild_log
    ${SCRIPT} >> ${LOG_FILE} 2>&1 &
    (dialog --colors --no-kill --backtitle "$(backtitle)" --title 'Aguarde o Resultado...' --tailbox $LOG_FILE 80 120 )
done
exit