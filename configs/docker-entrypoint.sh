#!/bin/bash
# Aguardando Provisionamento do Mariadb
echo " -- Aguardando Banco de Dados ..."
sleep 30
# Ajustando Memoria do PHP
echo "memory_limit = ${PHP_MEMORY}M" >> /etc/php.ini
# Instalando Moodle
install=$(ls /var/www/html/moodle/config.php | wc -l)
if [ $install -eq 1 ]; then
	echo "Ignorando instalacao inicial"
else
	echo " -- Iniciando Instalacao do Moodle ..."
	if [ "${MOODLE_SKIP_INSTALL}" == "no" ]; then
		/usr/bin/php /var/www/html/moodle/admin/cli/install.php --chmod=2777 --dataroot=/var/www/moodledata --wwwroot=${MOODLE_URL} --dbtype=mariadb --dbhost=${MOODLE_MARIADB_HOST} --dbname=${MOODLE_MARIADB_BD} --dbuser=${MOODLE_MARIADB_USER} --dbpass=${MOODLE_MARIADB_PASS} --dbport=3306 --adminuser=${MOODLE_USER} --adminpass=${MOODLE_USER_PASS} --adminemail=${MOODLE_USER_EMAIL} --fullname=Moodle --shortname=Docker --non-interactive --agree-license --allow-unstable
		
		# Ajustando config.php
		chmod o+r /var/www/html/moodle/config.php
		
		# Removendo moodle package
		rm -rf /moodle-latest-38.tgz

		# Editando arquivo httpd.conf
		echo "ServerName moodle" >> /etc/httpd/conf/httpd.conf
	else
		echo "=> Usando uma instalacao existente"
	fi
fi

# Iniciando Apache
echo " -- Iniciando o Apache - OK ..."
rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND
