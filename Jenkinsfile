pipeline {
    agent any

    environment {
        EMAIL = 'allisonnavalles1408@gmail.com'
        NODE_ENV = 'development'
        SLACK_WEBHOOK_URL = credentials('slack-webhook') // Define esta credencial en Jenkins como "Secret text"
    }

    tools {
        nodejs 'NodeJS 16' // Asegúrate de que este nombre exista en Jenkins > Global Tool Configuration
    }

    options {
        timestamps()
    }

    stages {
        stage('Clonar código') {
            steps {
                git url: 'https://github.com/Cesar-Fex04/ApiSlack.git', branch: "${env.BRANCH_NAME}"
            }
        }

        stage('Instalar dependencias') {
            steps {
                sh 'pip install -r requirements.txt || true'  // Para Python (opcional)
                sh 'npm install || true'                      // Para Node.js
            }
        }

        stage('Pruebas') {
            steps {
                script {
                    try {
                        sh 'pytest tests/ || npm test'
                    } catch (err) {
                        currentBuild.result = 'FAILURE'
                        error("❌ Pruebas fallidas. Abortando despliegue.")
                    }
                }
            }
        }

        stage('Compilar') {
            steps {
                sh 'npm run build || true' // Si aplica para el proyecto
            }
        }

        stage('Desplegar') {
            when {
                branch 'main'
            }
            steps {
                sh './scripts/deploy.sh || ./deploy.sh'
            }
        }
    }

    post {
        success {
            echo '✅ Build exitoso.'
            slackSend(
                webhookUrl: "${env.SLACK_WEBHOOK_URL}",
                channel: "#alertas",
                color: 'good',
                message: "✅ Build ${env.BUILD_NUMBER} exitoso en ${env.JOB_NAME}"
            )
            emailext(
                subject: "✔️ Build SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "La rama ${env.BRANCH_NAME} pasó pruebas y fue desplegada.",
                to: "${EMAIL}"
            )
        }

        failure {
            echo '❌ Build fallido.'
            slackSend(
                webhookUrl: "${env.SLACK_WEBHOOK_URL}",
                channel: "#alertas",
                color: 'danger',
                message: "❌ Build ${env.BUILD_NUMBER} fallido en ${env.JOB_NAME}"
            )
            emailext(
                subject: "❌ Build FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Falló la build en la rama ${env.BRANCH_NAME}. Revisa Jenkins: ${env.BUILD_URL}",
                to: "${EMAIL}"
            )
        }
    }
}
                to: "${EMAIL}"
            )
        }
    }
}
