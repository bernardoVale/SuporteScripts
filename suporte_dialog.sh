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
# Pé de macaco para conseguir dar um exit numa subfunction
trap "exit 1" TERM
export TOP_PID=$$
#############################################################
#-----------------------------------------------------------
#               UTILITÁRIOS DO DIALOG
#
#   São declaradas aqui funções de exibição do menu.
#------------------------------------------------------------
backtitle(){
    echo "LB2 - Leading Business to the Next Level"
}
cabecalho(){
    echo -e "\n\t\t\t\t \Z1RESPONSABILIDADES\Zn \n
    Oracle Database: Oracle 12c - Container Database (cdbdev) \n
    Oracle Database(pdbhd): Banco de desenvolvimento do Helpdesk \n
    Oracle Database(pdbsp): Banco de desenvolvimento do Sales Collaboration \n
    $CURRENT_STATUS"
}
#############################################################
#-----------------------------------------------------------
#           DECLARAÇÃO DAS OPÇÕES DO MENU
#
#   Função para definir as opções do menu inicial.
#
# $OPTIONS = Variável Global
#
# "nome retornado" "Texto exibido na frente (Descrição)"
# O "nome retornado" será comparado no IF do método
# choose_script
#------------------------------------------------------------
build_options(){
    options=("Oracle Status" "Verifica o status de todas as instancias Oracle"
         "Iniciar Oracle" "Inicia todos os bancos e listeners do ambiente"
         "Parar Oracle" "Desliga todos os bancos e listeners do ambiente"
         "Listener Status" "Verifica o status de todos os listeners"
         "Parar Listener" "Desliga todos os listeners do ambiente"
         "Iniciar Listener" "Desliga todos os listeners do ambiente")
}
#############################################################
#############################################################
#-----------------------------------------------------------
#           DECLARAÇÃO DOS NOMES NO MENU
#
#   Função para definir qual script será executado
#
# $SCRIPT = Variável Global
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
        kill -s TERM ${TOP_PID}
    fi
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
#               CURRENT STATUS
#
#   Método com objetivo de executar os scripts de status
# ao iniciar o menu.
#
#   Variável Global= CURRENT_STATUS resultado dos scripts
# seu valor é adicionado no método CABECALHO
#------------------------------------------------------------
current_status(){
    CURRENT_STATUS="\t\t\t\t \Z4\ZbStatus do Ambiente\Zn \n \n"
    script_01=$(oracle_status)
    script_02=$(listener_status)
    CURRENT_STATUS="$CURRENT_STATUS `eval ${script_01}`"
    # Script do listener precisar ser melhorado para trazer um resultado user-friendly
    #CURRENT_STATUS="$CURRENT_STATUS `eval ${script_02}`"
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
#-----------------------------------------------------------
#               MAIN METHOD
#
#   Aqui esta o ciclo do script que consiste em exibir um
# menu com as opções definidas no método BUILD_OPTIONS
# e configuradas no CHOOSE_SCRIPT.
#
#  Este método não precisa ser modificado.
#------------------------------------------------------------
while true
do
    current_status
    CABECALHO=$(cabecalho)
    build_options
    cmd=(${DIALOG} --colors --stdout --no-collapse --backtitle "$(backtitle)" \
    --title 'LB2-Dev12c' --menu "$CABECALHO" 0 0 0)
    RESPOSTA=$("${cmd[@]}" "${options[@]}")
    choose_script "$RESPOSTA"
    rebuild_log
    ${SCRIPT} >> ${LOG_FILE} 2>&1 &
    (dialog --colors --no-kill --backtitle "$(backtitle)" --title 'Aguarde o Resultado...' \
    --tailbox $LOG_FILE 80 120 )
done
exit
#############################################################