pipeline {
    agent any

    environment {
        EMAIL = 'tuemail@ejemplo.com'
    }

    stages {
        stage('Clonar código') {
            steps {
                git url: 'https://github.com/tuusuario/tu-repo.git', branch: "${env.BRANCH_NAME}"
            }
        }

        stage('Instalar dependencias') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Pruebas') {
            steps {
                sh 'pytest tests/'
            }
        }

        stage('Construir') {
            steps {
                echo "Compilando en la rama ${env.BRANCH_NAME}..."
            }
        }

        stage('Desplegar') {
            when {
                branch 'main'
            }
            steps {
                echo 'Desplegando...'
                sh './scripts/deploy.sh'
            }
        }
    }

    post {
        success {
            emailext (
                subject: "✔️ Build SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "La rama ${env.BRANCH_NAME} se construyó y pasó las pruebas.",
                to: "${EMAIL}"
            )
        }

        failure {
            emailext (
                subject: "❌ Build FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Falló en la rama ${env.BRANCH_NAME}.",
                to: "${EMAIL}"
            )
        }
    }
}
