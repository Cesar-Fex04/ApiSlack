pipeline {
  agent any

  environment {
    // Credenciales que guardaste en Jenkins
    DEPLOY_CREDENTIALS = credentials('ssh-deploy-key')
    SLACK_WEBHOOK      = credentials('slack-webhook-url')
    RECIPIENTS         = 'equipo@empresa.com'
  }

  triggers {
    // Poll SCM cada 5 minutos (o comentar si usas webhook)
    pollSCM('H/5 * * * *')
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'git@github.com:tuOrg/tuRepo.git', branch: 'main'
      }
    }

    stage('Build') {
      steps {
        sh './gradlew clean build -x test'   // o el comando que uses
      }
    }

    stage('Test') {
      steps {
        sh './gradlew test'                  // corre tus tests
        junit 'build/test-results/**/*.xml'  // publica reportes JUnit
      }
    }

    stage('Deploy') {
      when {
        branch 'main'    // Solo deploy desde main
      }
      steps {
        // Ejemplo de despliegue por SSH
        sshagent (credentials: ["${DEPLOY_CREDENTIALS}"]) {
          sh """
            scp build/libs/app.jar user@servidor:/opt/apps/
            ssh user@servidor 'systemctl restart mi-servicio'
          """
        }
      }
    }
  }

  post {
    success {
      slackSend (
        channel: '#deployments',
        webhookUrl: env.SLACK_WEBHOOK,
        color: 'good',
        message: "✅ *BUILD EXITOSO* para `${env.JOB_NAME}` #${env.BUILD_NUMBER} (<${env.BUILD_URL}|ver>)"
      )
      emailext (
        to:     "${env.RECIPIENTS}",
        subject: "✅ Build SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body:   """<p>¡Hola equipo!</p>
                  <p>El build <b>${env.JOB_NAME} #${env.BUILD_NUMBER}</b> ha finalizado con éxito.</p>
                  <p><a href="${env.BUILD_URL}">Ver detalles</a></p>"""
      )
    }
    failure {
      slackSend (
        channel: '#alerts',
        webhookUrl: env.SLACK_WEBHOOK,
        color: 'danger',
        message: "❌ *BUILD FALLIDO* para `${env..JOB_NAME}` #${env.BUILD_NUMBER} (<${env.BUILD_URL}|ver>)"
      )
      emailext (
        to:     "${env.RECIPIENTS}",
        subject: "❌ Build FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body:   """<p>¡Atención!</p>
                  <p>El build <b>${env.JOB_NAME} #${env.BUILD_NUMBER}</b> ha fallado.</p>
                  <p>Revisa los logs: <a href="${env.BUILD_URL}">aquí</a>.</p>"""
      )
    }
    always {
      // Limpieza u otras tareas que quieras en cualquier caso
      cleanWs()
    }
  }
}
