pipeline {
    agent any
    tools {
        go 'go'
        // dockerTool 'docker'
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
                script {
                def path = env.PATH
                echo "PATH: ${path}"
                }
            }
        }
        stage('trivy') {
            steps {
                script {
                     try {
                         sh 'ls -la'
                         sh 'docker build -t mygo:latest -f Dockerfile-main .'
                         // sh 'docker run -u root -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 0 --format json --output test.json'
                         def image = docker.image('bitnami/trivy')
                         image.inside('--entrypoint='sh' -v /var/run/docker.sock:/var/run/docker.sock') {
                             sh 'docker ps'
                         }
                     }
                     catch (err) {
                         echo err.getMessage()
                         // currentBuild.result = "FAIL"
                         // error 'You\'ve failed the Trivi'
                         sh 'ls -la Caches'
                         sh 'pwd'
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
