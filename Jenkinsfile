pipeline {
    agent any

    environment {
        NODEJS_HOME = tool name: 'Node 18', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
        PATH = "${NODEJS_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm run test'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Setup Vercel CLI') {
            steps {
                sh 'npm i -g vercel'
            }
        }

        stage('Validate PR (Preview Build)') {
            when {
                expression { env.BRANCH_NAME != 'main' }
            }
            steps {
                withCredentials([string(credentialsId: 'vercel-token', variable: 'VERCEL_TOKEN')]) {
                    sh '''
                        vercel pull --yes --token=$VERCEL_TOKEN
                        vercel build --token=$VERCEL_TOKEN
                    '''
                }
            }
        }

        stage('Deploy Preview to Vercel') {
            when {
                expression { env.BRANCH_NAME != 'main' }
            }
            steps {
                withCredentials([string(credentialsId: 'vercel-token', variable: 'VERCEL_TOKEN')]) {
                    sh 'vercel deploy --prebuilt --token=$VERCEL_TOKEN'
                }
            }
        }

        stage('Deploy to Vercel (main only)') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([string(credentialsId: 'vercel-token', variable: 'VERCEL_TOKEN')]) {
                    sh 'vercel --prod --token=$VERCEL_TOKEN'
                }
            }
        }
    }

    post {
        failure {
            mail to: 'tu_email@dominio.com',
                 subject: "Fallo en Pipeline: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Revisa Jenkins para más detalles: ${env.BUILD_URL}"

            slackSend channel: '#alertas',
                      color: 'danger',
                      message: "❌ Fallo en el build de `${env.JOB_NAME}` (#${env.BUILD_NUMBER})"
        }

        success {
            slackSend channel: '#alertas',
                      color: 'good',
                      message: "✅ Build exitoso: `${env.JOB_NAME}` (#${env.BUILD_NUMBER})"
        }
    }
}
