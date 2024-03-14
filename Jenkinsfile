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
        stage('Build app') {
            steps {
                sh 'go build -o main ./...'
            }
        }
        stage('sonar scanner') {
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
        stage('trivy scan') {
            steps {
                script {
                     try {
                         sh 'ls -la'
                         sh 'docker build -t mygo:latest -f Dockerfile-main .'
                         // sh 'docker run -u root -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 0 --format json --output test.json'
                         def image = docker.image('aquasec/trivy:latest')
                         image.inside('--entrypoint \'\' -v /var/run/docker.sock:/var/run/docker.sock') {
                             sh 'ls -la'
                             sh 'trivy --version'
                             sh 'trivy image mygo:latest --format json --output test.json '
                             sh 'ls -la'
                         }
                     }
                     catch (err) {
                         echo err.getMessage()
                         // currentBuild.result = "FAIL"
                         // error 'You\'ve failed the Trivi'
                         sh 'ls -la Caches'
                         sh 'pwd'
                     }
                     
                    // sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.49.1 image python:3.4-alpine'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'ls -la'
                echo 'Deploying...'
            }
        }
        stage('zap scan') {
            steps {
                script {
                    def zap = docker.image('owasp/zap2docker-stable:latest')
                    zap.inside('--entrypoint '\'\ ') {
                        // sh 'zap-full-scan.py -t "https://" -r zap-report.html || true'
                    }
                }
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
