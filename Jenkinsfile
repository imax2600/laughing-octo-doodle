pipeline {
    agent any
    tools {
        go 'go'
        hudson.plugins.sonar.SonarRunnerInstallation 'sonar'
    }
    stages {
        stage('Build') {
            steps {
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
