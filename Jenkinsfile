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
                    sh 'ls -la /var/jenkins_home/tools/org.jenkinsci.plugins.docker.commons.tools.DockerTool/'
                   sh '/var/jenkins_home/tools/org.jenkinsci.plugins.docker.commons.tools.DockerTool/docker build -t test .'
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
