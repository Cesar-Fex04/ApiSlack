pipeline {
  agent any

  environment {
    NODE_ENV = 'development'
  }

  options {
    timestamps()
  }

  tools {
    nodejs "NodeJS 16"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Instalar dependencias') {
      steps {
        sh 'npm install'
      }
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

    stage('Build') {
      steps {
        sh 'npm run build'
      }
    }

    stage('Despliegue') {
      when {
        expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
      }
      steps {
        sh './deploy.sh'
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
           body: """\
La build falló.

Proyecto: ${env.JOB_NAME}
Número de build: ${env.BUILD_NUMBER}
Ver detalles en: ${env.BUILD_URL}
"""
    }
  }
}
