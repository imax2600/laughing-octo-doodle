pipeline {
    agent any
    tools {
        go 'go'
        dockerTool 'docker'
    }   
    stages {
         stage('Setup') {
            steps {
                script {
                    // sh 'newgrp docker '
                    // sh 'usermod -aG docker jenkins'
                    // sh 'usermod -aG root jenkins'
                    sh 'ls -la /var/run/'
                    sh 'whoami'
                    sh 'ls -la /var/jenkins_home/tools/org.jenkinsci.plugins.docker.commons.tools.DockerTool/docker/bin/'
                   sh '/var/jenkins_home/tools/org.jenkinsci.plugins.docker.commons.tools.DockerTool/docker/bin/docker ps'
                    sh 'docker ps'
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
