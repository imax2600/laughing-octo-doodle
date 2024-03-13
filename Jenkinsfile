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
        // stage('Build') {
        //     steps {
        //         // Build your Go project
        //         sh 'go build ./...'
        //     }
        // }
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
                echo 'Testing...'
            }
        }
        stage('trivy') {
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
