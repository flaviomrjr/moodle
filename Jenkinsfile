pipeline {

    agent any
    
    environment {
        	WORKSPACE_JENKINS = '$WORKSPACE'
	}
    
    stages {
        stage("Git"){
            steps {
                cleanWs()
                git branch: 'master',
                credentialsId: 'github-user',
                url: 'https://github.com/flaviomrjr/moodle.git'
            }
        }

	stage("Deploy em Dev"){
            steps {
                ansiblePlaybook(
                    inventory: '/etc/ansible/hosts',
                    playbook: '${WORKSPACE}/deploy-moodle.yml',
                    credentialsId: 'devops-ssh',
                    extras: '-e "host=server_ip env=dev" -t "backup,deploy"'
                )
            
                slackSend (color: 'good',
                message: '[ sucesso ] Deploy em Dev finalizado - acesse em: https://dev.yourdomain.com/',
                tokenCredentialId: 'slack-token') 
            }
        }
        
        stage("Deploy em cert?"){
            steps { 
                script { 
                    slackSend (color: 'warning', message: "Para aplicar a mudança em cert, acesse [Janela de 30 minutos]: ${JOB_URL}", tokenCredentialId: 'slack-token') 
                    timeout(time: 30, unit: 'MINUTES') { 
                        input(id: "Deploy Gate", message: "Deploy em cert?", ok: 'Deploy') 
                    } 
                } 
            }
        }
        
        stage("Deploy em Cert"){
            steps {
                ansiblePlaybook(
                    inventory: '/etc/ansible/hosts',
                    playbook: '${WORKSPACE}/deploy-moodle.yml',
                    credentialsId: 'devops-ssh',
                    extras: '-e "host=server_ip env=cert" -t "backup,deploy"'
                )
            
                slackSend (color: 'good',
                message: '[ sucesso ] Deploy em Cert finalizado - acesse em: https://cert.yourdomain.com/',
                tokenCredentialId: 'slack-token') 
            }
        }
        
        stage("Deploy em producao?"){
            steps { 
                script { 
                    slackSend (color: 'warning', message: "Para aplicar a mudança em produção, acesse [Janela de 30 minutos]: ${JOB_URL}", tokenCredentialId: 'slack-token') 
                    timeout(time: 10, unit: 'MINUTES') { 
                        input(id: "Deploy Gate", message: "Deploy em producao?", ok: 'Deploy') 
                    } 
                } 
            }
        }
        
        stage("Deploy"){
            steps {
                ansiblePlaybook(
                    inventory: '/etc/ansible/hosts',
                    playbook: '${WORKSPACE}/deploy-moodle.yml',
                    credentialsId: 'devops-ssh',
                    extras: '-e "host=server_ip env=prod" -t "backup,deploy"'
                )
            
                slackSend (color: 'good',
                message: '[ sucesso ] Deploy em Producao finalizado - acesse em: http://moodle.yourdomain.com/',
                tokenCredentialId: 'slack-token')
            }
        }
    }
}
