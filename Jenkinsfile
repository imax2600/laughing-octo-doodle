pipeline {
    agent any
    tools {
        go '1.22.1'
    }
    stages {
        stage('Build') {
            steps {
                sh 'go version'
                echo 'Building...'
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
