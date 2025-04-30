pipeline {
    agent any

    // Si prefieres usar polling en lugar de un webhook:
    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Cesar-Fex04/ApiSlack.git'
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Compilando el proyecto...'
                // Aquí tu comando real de build, por ejemplo:
                // sh './gradlew clean build -x test'
            }
        }

        stage('Test') {
            steps {
                echo '🧪 Ejecutando pruebas...'
                // Aquí tu comando real de test, por ejemplo:
                // sh './gradlew test'
            }
            post {
                // Publica resultados JUnit si usas JUnit
                always {
                    junit '**/build/test-results/**/*.xml'
                }
            }
        }

        stage('Deploy') {
            when {
                // Solo despliega si todo va bien
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                echo '🚀 Desplegando aplicación...'
                // Ejemplo con SSH agent:
                // sshagent(['ssh-deploy-key']) {
                //   sh 'scp path/to/artifact user@servidor:/ruta/'
                //   sh 'ssh user@servidor "systemctl restart servicio"'
                // }
            }
        }
    }

    post {
        success {
            slackSend(
                channel: '#deployments',
                color: 'good',
                message: "✅ *BUILD EXITOSO* - `${env.JOB_NAME}` #${env.BUILD_NUMBER} (<${env.BUILD_URL}|ver>)"
            )
        }
        failure {
            slackSend(
                channel: '#deployments',
                color: 'danger',
                message: "❌ *BUILD FALLIDO* - `${env.JOB_NAME}` #${env.BUILD_NUMBER} (<${env.BUILD_URL}|ver>)"
            )
        }
        always {
            cleanWs()
        }
    }
}
