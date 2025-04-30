pipeline {
    agent any

    environment {
        // Solo si necesitas un webhook manual más adelante
        // SLACK_WEBHOOK = credentials('slack-webhook-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Cesar-Fex04/ApiSlack.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Compilando el proyecto...'
                // comandos de build si aplican
            }
        }

        stage('Tests') {
            steps {
                echo 'Ejecutando pruebas...'
                // comandos de pruebas, por ejemplo:
                sh 'echo test exitoso'
            }
        }

        stage('Deploy') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo 'Desplegando aplicación...'
                // comandos reales de despliegue aquí
            }
        }
    }

    post {
        success {
            slackSend (
                channel: '#deployments',
                color: 'good',
                message: "✅ *BUILD EXITOSO* - `${env.JOB_NAME}` #${env.BUILD_NUMBER} (<${env.BUILD_URL}|ver>)"
            )
        }

        failure {
            slackSend (
                channel: '#deployments',
                color: 'danger',
                message: "❌ *BUILD FALLIDO* - `${env.JOB_NAME}` #${env.BUILD_NUMBER} (<${env.BUILD_URL}|ver>)"
            )
        }
    }
}
