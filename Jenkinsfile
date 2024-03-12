pipeline {
    agent { docker{ image 'alpine:latest' } 
          }
    tools {
        go 'go'
        dockerTool 'docker'
    }   
    stages {
         stage('Setup') {
            steps {
                script {
                    def myEnv = docker.build 'my-environment:snapshot'
                    myEnv.inside {
                        sh 'ls -la'
                    }
                }
            }
        }
        stage('Build') {
            steps {
                // Build your Go project
                sh 'go build ./...'
            }
        }
        stage('Build2') {
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
