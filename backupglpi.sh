#!/bin/bash
# Nome : glpibackup.sh
# Versão: 2.0
# Autor : André Cabral
# Email : alcs.deh@gmail.com
# telegram: @domcabral9
# Site : www.domcabral.net
# Descrição :  O script glpibackup faz  o bacup do banco de dados e diretório do glpi, possui as opções  
# all (backup completo) e small (backup dos dados e pics, files e plugins do glpi), o processo de 
# autenticação do banco de dados usa o unix_socket evitando a exposição da senha, também é  gerado um 
# arquivo de logs quando o configuramos no cron.


#VARIAVEIS
data=$(date +"%Y-%m-%d_%H-%M")
dirglpi=/var/www/html/glpi
bkpglpi=/home/backups/glpi
logglpi=/var/log/backupglpi

# CRIANDO DIRETÓRIO DE BACKUP
if [ ! -d $bkpglpi/ ]; then
	mkdir  -m 770 -p $bkpglpi/
	chown .backup $bkpglpi -Rf
fi

# CRIANDO DIRETÓRIO DE LOGS
if [ ! -d  $logglpi ]; then
	mkdir $logglpi
	chmod  775 $logglpi
	chown  .backup $logglpi -Rf
fi

cd $dirglpi

case $1 in

 small)

	## Backup arquivos glpi
	
	zip -r $bkpglpi/$data-bkpglpi-small.zip files/ plugins/ pics/  -x files/_sessions/*

	## Backup banco glpi
	
	mysqldump -u backupadmin  glpidb --ignore-table=glpidb.glpi_notimportedemails >  files/_dumps/$data.sql
	zip -ur $bkpglpi/$data-bkpglpi-small.zip files/_dumps/$data.sql
	rm files/_dumps/$data.sql

	;;
	
 all)

	## Backup arquivos glpi

	zip -r $bkpglpi/$data-bkpglpi-all.zip ./  -x files/_sessions/*

	## Backup banco 
	
	mysqldump -u backupadmin  glpidb --ignore-table=glpidb.glpi_notimportedemails >  files/_dumps/$data.sql
	zip -ur $bkpglpi/$data-bkpglpi-all.zip files/_dumps/$data.sql
	rm files/_dumps/$data.sql

	;;

 *)

	echo "Opção inexistente"
	;;

esac