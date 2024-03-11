pipeline {
    agent any
    tools {
        go 'go'
    }
    stages {
        stage('Build') {
            steps {
              withSonarQubeEnv('sonarQ', envOnly: true) {
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
