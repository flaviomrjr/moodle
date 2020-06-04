MOODLE - AUTOMATION
===================

Esse projeto integra ferramentas DevOps para garantir o deploy do ambiente e aplicação Moodle.

Essas são as ferramentas utilizadas e suas funções:

FERRAMENTA | FUNÇÃO
-----------|-------
**Rundeck**    | Responsável pelo deploy do ambiente (cert/prod), acionando a role Ansible **"docker-moodle"** no servidor de automação.
**Ansible**    | Responsável em aplicar as configurações em nosso servidor de aplicação, utilizando o Docker para subir os containers de cada ambiente.
**Docker**     | Responsável pelo gerenciamento dos containers do servidor de aplicação.  
**Puppet**     | Responsável em instalar e garantir o Docker no servidor de aplicação.  
**Jenkins**    | Responsável pelo deploy da aplicação (CI/CD), acionando a role Ansible **"deploy-moodle"** no servidor de automação.
**Vagrant**    | Responsável pelo deploy do ambiente (dev), acionando a role Ansible **"docker-moodle"** no computador do desenvolvedor.

DEPLOY DO AMBIENTE
------------------

Para esse projeto, precisamos de um servidor de automação e outro servidor de aplicação.

* **REQUISITOS DO SERVIDOR - AUTOMAÇÃO**
  - **Rundeck**
    - Link para instalação: https://docs.rundeck.com/docs/administration/install/
    - Criar o projeto MOODLE;
    - Importar os jobs "DEPLOY/BACKUP/RESTORE/DESTROY" dentro da pasta rundeck do repositório;    
  - **Ansible**
    - Link para instalação: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
    - Chave SSH para acesso ao servidor de aplicação
      ```shell
      ssh-keygen
      ssh-copy-id user@server_aplicacao_ip
      ```
  - **Puppet** - _OPCIONAL_
    - Link para instalação: https://puppet.com/docs/puppetserver/6.0/install_from_packages.html
    - Criar um modulo docker, utilizando o manifest do repositório **init.pp**
    - _**OBS**_: Caso você não configure o Puppet, deve realizar a instalação do docker no servidor de aplicação.
  - **Jenkins**
    - Link para instalação: https://jenkins.io/doc/book/installing/
    - Plugins: Gitlab ou Github, Slack, Ansible;
    - Criação do job "deploy-moodle"
      - Configurar o "Build Trigger" a partir do push feito para o repositório do Gitlab ou GitHub;
      - Configurar o Jenkinsfile a partir do repositório;
    - Configurar a integração do plugin Slack com o canal que receberá as notificações da pipeline.
  - **Gitlab** - _OPCIONAL_
    - Link para instalação: https://docs.gitlab.com/ee/install/
    - Importar o repositório moodle
    - Criar webhook para integração do Gitlab ao Job de (CI/CD) criado no Jenkins.
      - Você irá encontrar a URL para a criação do webhook no proprio Job do Jenkins em => Build Triggers => Build when a change is pushed to GitLab;
    - _**OBS**_: Seu repositório pode estar em outro lugar como o GitHub, porém a integração via webhook deve ser criada independente do repositório.


* **CONFIGURANDO O SLACK**
  - Instale o plugin do Jenkins em seu Slack;
  - Siga os passos de integração entre o Slack e Jenkins utilizando o próprio manual disponibilizado no Slack.


* **REQUISITOS DO SERVIDOR - APLICACÃO**
  - Docker - _OPTANDO EM NÃO  UTILIZAR O PUPPET_
    - Link para instalação: https://docs.docker.com/install/

**PROVISIONANDO O AMBIENTE**

- **Acesse o Rundeck**
  - Execute o Job "DEPLOY" informando os parâmetros necessários para os ambientes de (cert/prod);
  - _**OBS**_: O Job "DEPLOY" deve ser executado por ambiente.

DEPLOY DA APLICAÇÃO
-------------------

_**CERT/PROD**_ - SERVIDOR DE APLICACAO

- **PONTOS DE ATENÇÃO**
  - Altere seu Jenkinsfile, inserindo os parâmetros do seu ambiente, por exemplo:
    - URLs
    - Portas
    - Chaves
  - Garanta a integração via webhook do seu repositório com o Jenkinsfile;
  - Garanta a integração do Jenkins com seu canal no Slack.

**FAZENDO O DEPLOY DA APLICAÇÃO**

- **Commit/Push**
  - Ao realizar o commit em seu repositório local e executar o push para o Gitlab/GitHub, automaticamente seu Job será acionado.
  - Ao terminar o processo de deploy em **cert**, você irá receber um link em seu canal no Slack para aprovar ou  não o deploy em produção.
  - _**OBS**_: A pipeline está configurada para aguardar até 10 minutos no processo de aprovação.


_**DEV**_ - PERSONAL COMPUTER  

- **REQUISITOS - ESTAÇÃO DE TRABALHO**
  - Vagrant
    - Link para instalação: https://www.vagrantup.com/docs/installation/


- **PONTOS DE ATENÇÃO**
  - Altere seu Vagrantfile, inserindo os parâmetros do seu ambiente, por exemplo:
    - Memória
    - CPU
    - Variaveis do ambiente de Dev como: Portas/Usuário/Senha/Email

**PROVISIONANDO O AMBIENTE**
 - Acesse a pasta do repositório;
 - Inicie o provisionando do ambiente com o comando:
  ```shell
  vagrant up
  ```
 - Acessando o servidor:
 ```shell
 vagrant ssh moodle
 ```

PIPLINE
=======

 ![IMAGEM GIT](https://github.com/flaviomrjr/moodle/blob/master/pipeline-moodle.png?raw=true)

 _**BY FLAVIO ROCHA - flavio.rocha16@gmail.com**_
