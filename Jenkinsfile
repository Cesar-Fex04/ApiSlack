pipeline {
     agent any
 ci-cd job {
   agent any
 
     environment {
         EMAIL = 'tuemail@ejemplo.com'
     }
   environment {
     // Variables globales si las necesitas
     NODE_ENV = 'development'
   }
 
     stages {
         stage('Clonar código') {
             steps {
                 git url: 'https://github.com/tuusuario/tu-repo.git', branch: "${env.BRANCH_NAME}"
             }
         }
   options {
     timestamps()
   }
 
         stage('Instalar dependencias') {
             steps {
                 sh 'pip install -r requirements.txt'
             }
         }
   tools {
     nodejs "NodeJS 16" // si usas NodeJS
   }
 
         stage('Pruebas') {
             steps {
                 sh 'pytest tests/'
             }
         }
   stages {
     stage('Checkout') {
       steps {
         checkout scm
       }
     }
 
         stage('Construir') {
             steps {
                 echo "Compilando en la rama ${env.BRANCH_NAME}..."
             }
         }
     stage('Instalar dependencias') {
       steps {
         sh 'npm install'
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
     stage('Pruebas') {
       steps {
         script {
           try {
             sh 'npm test'
           } catch (err) {
             currentBuild.result = 'FAILURE'
             error("❌ Pruebas fallidas. Abortando despliegue.")
           }
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
     stage('Build') {
       steps {
         sh 'npm run build' // o el comando que uses para compilar
       }
     }
 
         failure {
             emailext (
                 subject: "❌ Build FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Falló en la rama ${env.BRANCH_NAME}.",
                 to: "${EMAIL}"
             )
         }
     stage('Despliegue') {
       when {
         expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
       }
       steps {
         sh './deploy.sh' // tu script de despliegue
       }
     }
   }
 
   post {
     success {
       echo '✅ Build exitoso y desplegado correctamente.'
       slackSend (color: 'good', message: "✅ Build ${env.BUILD_NUMBER} exitoso en ${env.JOB_NAME}")
     }
     failure {
       echo '❌ Build fallido.'
       slackSend (color: 'danger', message: "❌ Build ${env.BUILD_NUMBER} fallido en ${env.JOB_NAME}")
       mail to: 'tuemail@ejemplo.com',
            subject: "❌ Falló la build ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Revisa Jenkins: ${env.BUILD_URL}"
     }
   }
 }
