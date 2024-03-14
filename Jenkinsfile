pipeline {
    agent any
    tools {
        go 'go'
        dockerTool 'docker'
        'hudson.plugins.sonar.SonarRunnerInstallation' 'sonar'
    }   
    stages {
        stage('check') {
            steps {
                sh 'docker --version'
                sh 'which docker'
            }
        }
        stage('Build') {
            steps {
                sh 'go build -o main ./...'
            }
        }
        stage('sonar scan') {
            steps {
                withSonarQubeEnv(installationName: 'sonar') {
                    sh '/var/jenkins_home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar/bin/sonar-scanner'
                }
            }
        }
        stage('build image') {
            steps {
                sh 'docker build -t mygo:latest -f Dockerfile-main .'
            }
        }
        stage('test docker') {
            agent {
                docker { image 'maven:3.9.6-amazoncorretto-8-debian-bookworm'}
            }
            steps {
                sh 'mvn --version'
            }
        }
        // stage('trivy') {
        //     steps {
        //         withDockerContainer(image: 'aquasec/trivy:canary', toolName: 'docker') {
        //                 echo 'I am inside docker'
        //                 sh 'ls'
        //         }
        //         script {
        //              try {
        //                  sh 'ls -la'
        //                  sh 'docker build -t mygo:latest -f Dockerfile-main .'
        //                  // sh 'docker run -u root -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 0 --format json --output test.json'
        //                  def image = docker.image('docker')
        //                  // image.withTool('docker').inside('-v /var/run/docker.sock:/var/run/docker.sock --privileged') {
        //                  //     sh 'ls'
        //                  // }
        //              }
        //              catch (err) {
        //                  echo err.getMessage()
        //                  // currentBuild.result = "FAIL"
        //                  // error 'You\'ve failed the Trivi'
        //                  sh 'ls -la Caches'
        //                  sh 'pwd'
        //              }
                     
        //             // sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.49.1 image python:3.4-alpine'
        //         }
        //     }
        // }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
    
    // post {
    //     success {
    //         archiveArtifacts '/var/jenkins_home/workspace/MyGo/Caches'
    //         echo 'Hello, world!'
    //     }
    // }
}
