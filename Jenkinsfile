pipeline {
    agent any
    tools {
        go 'go'
    }
    environment {
        SCANNER_HOME = scannerHome
    }
    stages {
        stage('Build') {
            steps {
              script {
                  def scannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
              }
              withSonarQubeEnv('sonarQ') {
                sh 'sonar-scanner'
              }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
    
    post {
        success {
            echo 'Hello, world!'
        }
    }
}
