Moodle
======

O Moodle é um popular software open source de ensino (LMS) para a entrega de cursos digitais e programas de estudo.

Para mais informações visite o site oficial: https://moodle.org/

Docker Compose
--------------

```shell
$ curl -sSL https://raw.githubusercontent.com/flaviomrjr/moodle/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

Prerequisitos
-------------

Para executar essa aplicação, você precisa do Docker Engine e Docker Compose caso opte em executar via docker-compose.

Como utilizar essa imagem
=========================
Executando o Moodle com um container de Banco de Dados
-------------------------------------------------------
Executando o Moodle com um servidor de banco de dados e a forma recomendada.
Você pode utilizar o docker-compose, ansible ou executar manualmente.

**Executando a aplicação com Docker Compose**

A pagina principal deste repositório possui um `docker-compose.yml` funcional.
Execute a aplicação executando os comandos a baixo:

```shell
$ curl -sSL https://raw.githubusercontent.com/flaviomrjr/moodle/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Executando a aplicação via Ansible**

A pagina principal deste repositório possui a role `docker-moodle` funcional.
Execute a aplicação executando os comandos a baixo:

```shell
$ ansible-playbook /etc/ansible/playbooks/docker-moodle.yml -e "host=dockerhost env=dev phpmemory=1024 user=admin pass=MoodleAdmin mail=moodle@yourdomain.com url=moodle.yourdomain.com dbport=3306" -t deploy
```

**Executando a aplicação manualmente**

Se você quiser executar a aplicação manualmente em vez de utilizar o docker-compose,
esses são os passos basicos que você deve executar:

1. Crie uma rede para a aplicação e banco de dados:

```shell
$ docker network create moodle
```

2. Crie um volume persistente para o MariaDB e crie o container do MariaDB:

```shell
$ docker volume create --name mysql_data
$ docker run -dti --name mariadb \
 -e MYSQL_ROOT_PASSWORD=moodle \
 -e MYSQL_USER=moodle \
 -e MYSQL_PASSWORD=moodle \
 -e MYSQL_DATABASE=moodle_database \
 --net moodle \
 --volume mysql_data:/var/lib/mysql \
 mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

3. Crie dois volumes persistentes para o Moodle e cria o container do Moodle:

```shell
$ docker volume create --name moodle_app
$ docker volume create --name moodle_data
$ docker run -dti --name mariadb \
 -e PHP_MOMORY=1024 \
 -e MOODLE_URL: http://moodle.yourdomain.com \
 -e MOODLE_MARIADB_HOST=moodle \
 -e MOODLE_MARIADB_BD=moodle_database \
 -e MOODLE_MARIADB_USER=moodle \
 -e MOODLE_MARIADB_PASS=moodle \
 -e MOODLE_USER=admin \
 -e MOODLE_USER_PASS=MoodleAdmin \
 -e MOODLE_USER_EMAIL=moodle@yourdomain.com \
 -e MOODLE_SKIP_INSTALL=no \
 --net moodle \
 --volume moodle_app:/var/www/html/moodle \
 --volume moodle_data:/var/www/moodledata \
 moodle
```

**Montando uma pasta persistente no host usando docker-Compose**

Isso requer uma pequena mudança no `docker-compose.yml` presente nesse repositório:

```shell
services:
  mariadb:
  ...
    volumes:
      - '/path/to/mariadb-persistence:/var/lib/mysql'
  ...
  moodle:
  ...
    depends_on:
      - mariadb
  ...
```

**Montando pastas persistentes manualmente**

Nesse caso você precisa especificar os diretórios que serão montados no comando `run`. O processo é o mesmo igual o apresentado anteriormente.

1. Se você não fez isso anteriormente, crie uma rede para a aplicação e o banco de dados:

```shell
$ docker network create moodle
```

2. Inicie o MariaDB na rede criada:

```shell
$ docker volume create --name mysql_data
$ docker run -dti --name mariadb \
 -e MYSQL_ROOT_PASSWORD=moodle \
 -e MYSQL_USER=moodle \
 -e MYSQL_PASSWORD=moodle \
 -e MYSQL_DATABASE=moodle_database \
 --net moodle \
 --volume /path/to/mariadb-persistence:/var/lib/mysql \
 mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

3. Execute o container do Moodle:

```shell
$ docker volume create --name moodle_app
$ docker volume create --name moodle_data
$ docker run -dti --name mariadb \
 -e PHP_MOMORY=1024 \
 -e MOODLE_URL: http://moodle.yourdomain.com \
 -e MOODLE_MARIADB_HOST=moodle \
 -e MOODLE_MARIADB_BD=moodle_database \
 -e MOODLE_MARIADB_USER=moodle \
 -e MOODLE_MARIADB_PASS=moodle \
 -e MOODLE_USER=admin \
 -e MOODLE_USER_PASS=MoodleAdmin \
 -e MOODLE_USER_EMAIL=moodle@yourdomain.com \
 -e MOODLE_SKIP_INSTALL=no \
 --net moodle \
 --volume moodle_app:/var/www/html/moodle \
 --volume moodle_data:/var/www/moodledata \
 moodle
```

Configuração
============

Variáveis de ambiente
---------------------

Quando você inicia a imagem do Moodle, você pode ajustar a configuração da instancia passando uma ou mais variáveis de ambiente no arquivo `docker-compose.yml` ou via `docker run` via linha de comando.

**Configuração do Usuário, Site e Database:**

`MOODLE_USER:` Usuário Moodle. Padrão: **admin**

`MOODLE_USER_PASS:` Senha do usuário Moodle. Padrão: **MoodleAdmin**

`MOODLE_USER_MAIL:` E-mail do usuário Moodle. Padrão: **moodle@yourdomain.com**

`MOODLE_URL:` URL de acesso ao Moodle. Padrão: **http://moodle.yourdomain.com**

`MOODLE_SKIP_INSTALL:` Não executa a instalação inicial do Moodle. Padrão: **no**

`MOODLE_MARIADB_HOST:` Define o servidor de banco de dados. Padrão: **mariadb**

`MOODLE_MARIADB_BD:` Define o banco de dados. Padrão: **moodle**

`MOODLE_MARIADB_USER:` Define o usuário de acesso ao banco de dados. Padrão: **moodle**

`MOODLE_MARIADB_PASS:` Define a senha do usuário de acesso ao banco de dados. Padrão: **moodle**

**Configuração do PHP:**

`PHP_MEMORY:` Define a quantidade de memoria que será utilizada pelo PHP. Padrão: **512**

**Configurações do Banco de Dados:**

`MYSQL_ROOT_PASSWORD:` Define a senha do usuário root do mariadb. Padrão: **moodle**

`MYSQL_USER:` Define o usuário do banco de dados. Padrão: **moodle**

`MYSQL_PASSWORD:` Define a senha do usuário do banco de dados. Padrão: **moodle**

`MYSQL_DATABASE:` Define o nome do banco de dados. Padrão: **moodle**

Para mais variáveis de ambiente, consulto o repositório oficial do Mariadb: https://hub.docker.com/_/mariadb  

Instalando novos pacotes de idiomas
-----------------------------------

Por padrão, esse container é instalado em Inglês. Mesmo assim, outro pacotes podem ser adicionados utilizando a inteface de Administração. Como requerimento, para um novo idioma funcionar completamente, o arquivo locale do sistema deve ser atualizado com o idioma desejado. Os idiomas `Português Brasil` e `Espanhol Espanha` já foram configurado. Para adicionar novos locales, você deve estender a imagem adicionando novos locales:

```shell
FROM flaviomrjr/moodle:latest
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
```

O idioma a cima já está configurado nessa imagem. Você deve alterar o idioma correspondendo com seu pacote de idioma recém instalado.

Trabalhando com Proxy SSL
-------------------------

Por padrão o Moodle não é instalado no protocolo HTTPS utilizando certificado SSL. Caso você queira utilizar o Moodle sendo acessado por um Proxy SSL, você precisa alterar o arquivo `config.php` localizado em `/var/www/html/moodle`

- Edite a URL para HTTPS:

```shell
$CFG->wwwroot   = 'https://moodle.yourdomain.com';
```

- Adiciona a opção ´proxyssl´ em baixo da URL:

```shell
$CFG->wwwroot   = 'https://moodle.yourdomain.com';
$CFG->proxyssl  = true;
```

Adicionando um VirtualHost customizado
--------------------------------------

Por padrão, o VirtualHost está configurado para aceitar todos os domínios com a opção `ServerAlias *`. Caso queira adcionar um novo VirtualHost, insira o mesmo em: `/etc/httpd/conf.d`

ANSIBLE
=======

Esse projeto possui a role `docker-moodle` com tasks configuradas para fazer a instalação dos requisitos do servidor de aplicação, deploy, backup, restore, update e clone do container Moodle e Banco de dados.

Instalando os requisitos
------------------------

Você deve executar a playbook `docker-moodle.yml` informando a tag `prereq`:

```shell
$ git clone https://github.com/flaviomrjr/devops.git

$ cd devops

$ ansible-playbook docker-moodle.yml -e "host=yourhost" -t prereq
```

Feito isso, realize a instalação do Docker manualmente ou utilize o Manifest Puppet desse repositorio `init.pp`, para instalação automatizada do Docker.

Deploy dos containers Moodle e MariaDB
----------------------------------------------

Realizado a instalação dos requisitos, seu ambiente está pronto para receber os containers do Moodle e MariaDB. Para realizar o deploy via ansible, execute a playbook `docker-moodle.yml` informando a tag `deploy`:

```shell
$ ansible-playbook docker-moodle.yml -e "host=yourhost env=moodle phpmemory=1024 user=admin pass=MoodleAdmin mail=moodle@yourdomain.com url=moodle.yourdomain.com dbport=3306" -t deploy
```

Depois de executado a playbook, aguarde o processo de instalação inicial do Moodle. Para ver os logs do container e acompanhar a instalação execute:

```shell
$ docker logs -f yourcontainer
```

CI/CD
=====

Esse repositorio possui uma pipeline em `Jenkinsfile`, com o objetivo de automatizar os deploys feitos na aplicação Moodle pela equipe de desenvolvimento.

Siga os passos a seguir, para montar seu ambiente de CI/CD.

**PONTOS DE ATENÇÃO**
  - Altere seu Jenkinsfile, inserindo os parâmetros do seu ambiente, por exemplo:
    - URLs
    - Portas
    - Chaves
  - Garanta a integração via webhook do seu repositório com o Jenkinsfile;
  - Garanta a integração do Jenkins com seu canal no Slack.

**FAZENDO O DEPLOY DA APLICAÇÃO**

**Commit/Push**
  - Ao realizar o commit em seu repositório local e executar o push para o Gitlab/GitHub, automaticamente seu Job será acionado.
  - Ao terminar o processo de deploy em **dev**, você irá receber um link em seu canal no Slack para aprovar ou não o deploy em cert/produção.
  - _**OBS**_: A pipeline está configurada para aguardar até 30 minutos no processo de aprovação.

**PIPELINE**
 ![IMAGEM GIT](https://github.com/flaviomrjr/moodle/blob/master/pipeline-moodle.png?raw=true)
 Essa imagem exibe a pipeline com o processo de deploy em Dev e depois em Produção. O Jenkinsfile do repositório está configurado para fazer deploy em Dev, Cert e Prod. Caso queira remover Cert, remova os passos de Cert no Jenkinsfile.

Vagrant
=======

O Vagrant é uma ferramenta desenvolvida pela Hashcorp com o objetivo de automatizar a criação de um ambiente de teste.

Caso você queira criar um ambiente de teste localmente em seu computador, esse repositório possuiu o arquivo `Vagrantfile` responsável pelo provisionamento do ambiente local. Siga os passos a seguir para criar o ambiente.

**REQUISITOS - ESTAÇÃO DE TRABALHO**
  - Vagrant
    - Link para instalação: https://www.vagrantup.com/docs/installation/


**PONTOS DE ATENÇÃO**
  - Altere seu Vagrantfile, inserindo os parâmetros do seu ambiente, por exemplo:
    - Memória
    - CPU
    - Variaveis do ambiente de Dev como: Portas/Usuário/Senha/Email

**PROVISIONANDO O AMBIENTE**
 - Acesse a pasta do repositório;
 - Inicie o provisionando do ambiente com o comando:
  ```shell
  $ vagrant up
  ```
 - Acessando o servidor:
 ```shell
 $ vagrant ssh moodle
 ```
 _**BY FLAVIO ROCHA - flavio.rocha16@gmail.com**_
