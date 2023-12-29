# Hito 4: CI

Instalo Jenkins en mi máquina.


## Pipeline

El siguiente pipeline es el que he realizado en Jenkins:

```jenkinsfile

pipeline {
    agent any

    stages {
        stage('tests') {
            steps {
                
                
                git branch: 'main',
                    url: 'https://github.com/rafaguzmanval/practicaCC'
                    
                sh '''cd app/frontend
                    docker run --network=host -v $(pwd):/home/mobiledevops/app rafaguzmanval/photopop
                '''
            
                echo 'fin'
                
                
            }
        }
    }
}

```


## Resultado de los tests
Ejecuto manualmente una build para comprobar que funciona el docker asociado.

![resultados](/docs/imgs/resultadosjenkins.png)


## Resultado de los builds automáticos al hacer push

Para poder hacer un build cada vez que se hace un push, es necesario que activemos Github webhooks.
Esto hace que una vez tengamos un push en nuestro repositorio, se envie un mensaje a Jenkins desde Github para
hacerselo saber.

Para ello debo usar otra herramienta llamada ngrok que permite hacer una pasarela que hace visible por internet mi
servidor de Jenkins.

![ngrok](/docs/imgs/ngrok.png)


![resultados](/docs/imgs/github%20webhook.png)


