FROM centos/httpd
MAINTAINER Flavio Rocha <flavio.rocha16@gmail.com>

# Instalando prerequisitos
RUN  yum update -y && \
yum -y install epel-release && \
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
yum -y install yum-utils && \
yum-config-manager --enable remi-php71 [Install PHP 7.1] && \
yum-config-manager --enable remi-php72 [Install PHP 7.2] && \
yum-config-manager --enable remi-php73 [Install PHP 7.3] && \
yum -y install php php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysqlnd php-cli php-mcrypt php-ldap wget php-zip vim php-opcache && \
yum -y reinstall glibc-common

# Configurando locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8; \
localedef -i es_ES -f UTF-8 es_ES.UTF-8; \
localedef -i pt_BR -f UTF-8 pt_BR.UTF-8; \
localedef -i en_AU -f UTF-8 en_AU.UTF-8

# Baixando aplicacao e criando diretorios de instalacao
RUN wget https://download.moodle.org/download.php/direct/stable38/moodle-latest-38.tgz

# Configurando crontab
RUN yum -y install cronie && \
echo "* * * * * /usr/bin/php /var/www/html/moodle/admin/cli/cron.php >/dev/null" >> /var/spool/cron/apache

# Definindo environments
ENV PHP_MEMORY 256
ENV MOODLE_URL https://moodle.yourdomain.com
ENV MOODLE_MARIADB_HOST mariadb
ENV MOODLE_MARIADB_BD moodle
ENV MOODLE_MARIADB_USER moodle
ENV MOODLE_MARIADB_PASS moodle
ENV MOODLE_USER admin
ENV MOODLE_USER_PASS MoodleAdmin
ENV MOODLE_USER_EMAIL moodle@yourdomain.com
ENV MOODLE_SKIP_INSTALL no

# Configurando Apache VirtualHost
COPY ./configs/moodle.conf /etc/httpd/conf.d/moodle.conf

# Copiando php.ini
COPY ./configs/php.ini /etc/php.ini

# Inserindo arquivo .htaccess
COPY ./configs/htaccess /var/www/html/moodle/.htaccess

# Configurando entrypoint
ADD ./configs/docker-entrypoint.sh /usr/local/bin/
RUN chmod -v +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
