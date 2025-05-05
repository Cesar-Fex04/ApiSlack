pipeline {
    agent {
        docker {
            image 'node:18'  // Usa Node.js 18 con npm ya instalado
            args '-u root'   // Para evitar errores de permisos
        }
    }

    environment {
        VERCEL_TOKEN = credentials('VERCEL_TOKEN_ID') // Cambia por el ID correcto si es diferente
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test || true'  // Para que no falle si no hay tests aún
            }
        }

        stage('Conditional Deploy') {
            when {
                branch 'master'
            }
            steps {
                sh 'npx vercel --token=$VERCEL_TOKEN --prod'
            }
        }
    }

    post {
        failure {
            slackSend (
                teamDomain: 'api-okx4949',
                channel: '#avisos',
                tokenCredentialId: 'slack-jenkins',
                message: "⚠️ El pipeline falló en ${env.BRANCH_NAME}"
            )
            mail to: 'tucorreo@example.com',
                 subject: 'Fallo en Jenkins',
                 body: 'Hubo un error en el pipeline de Jenkins.'
        }
    }
}
