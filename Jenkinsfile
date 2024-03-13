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
                    sh 'pwd'
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
        // stage('build image') {
        //     steps {
        //         sh 'docker build -t mygo:latest -f Dockerfile-main .'
        //     }
        // }
        stage('trivy') {
            steps {
                script {
                    // def dockerImagesOutput = sh(script: 'docker images --format "{{.Repository}}:{{.Tag}}"', returnStdout: true).trim()

                    // // Split the output into lines
                    // def images = dockerImagesOutput.split('\n')

                    // // Search for the image name containing "mygo"
                    // def mygoImage = images.find { it.contains('mygo') }
            
                    // // Print the image if found
                    // echo "Found image: $mygoImage"
                    // // sh 'docker inspect -f . mygo:latest'
                    // def image = docker.image('mygo:latest')

                    // docker.image('maven:3.3.3-jdk-8').inside {
                    //       git '…your-sources…'
                    //       sh 'mvn -B clean install'
                    // }
                    // image.inside {
                    //     sh 'ls -la'
                    // }
                     try {
                         sh 'ls -la'
                         sh 'docker build -t mygo:latest -f Dockerfile-main .'
                         sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 1 --format json --output /root/.cache/test.json'
                     }
                     catch (err) {
                         echo err.getMessage()
                         // currentBuild.result = "FAIL"
                         // error 'You\'ve failed the Trivi'
                         sh 'ls -la Caches'
                     }
                     
                    // sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.49.1 image python:3.4-alpine'
                }
            }
        }
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
