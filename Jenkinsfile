pipeline {
    agent {
        docker {
            label 'Docker' // Specify the label of the Docker cloud you configured
            image 'alpine:latest' // Specify the Docker image to use for the Jenkins build agent
        }
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
