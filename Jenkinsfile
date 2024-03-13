pipeline {
    agent any
    tools {
        go 'go'
        dockerTool 'docker'
        'hudson.plugins.sonar.SonarRunnerInstallation' 'sonar'
    }   
    stages {
         stage('Setup') {
            steps {
                script {
                    sh 'docker ps'
                }
            }
        }
        stage('Build') {
            steps {
                // Build your Go project
                sh 'go build -o main ./...'
            }
        }
        stage('sonar scan') {
            // environment {
            //     SCANNER_HOME = "${scannerHome}"
            // }
            steps {
                withSonarQubeEnv(installationName: 'sonar') {
                    sh '/var/jenkins_home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar/bin/sonar-scanner'
                    //sh 'sonar-scanner'
                }
            }
        }
        stage('build image') {
            steps {
                echo 'docker build -t mygo Dockerfile-main'
            }
        }
        stage('trivy') {
            steps {
                script {
                    sh 'docker run aquasec/trivy image python:3.4-alpine'
                }
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
