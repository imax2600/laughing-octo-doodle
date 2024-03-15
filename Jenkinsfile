pipeline {
    agent any
    tools {
        go 'go'
        // dockerTool 'docker'
        // 'hudson.plugins.sonar.SonarRunnerInstallation' 'sonar'
    }   
    stages {
        stage('check') {
            steps {
                script {
                def changedFiles = []
                for (changeLogSet in currentBuild.changeSets) {
                for (entry in changeLogSet.getItems()) { 
                for (file in entry.getAffectedFiles()) {
                    echo file.getPath() // add changed file to list
                }
                }
                }
                }
            }
        }
        stage('Build app') {
            steps {
                sh 'go build -o main ./...'
            }
        }
        stage('sonar scanner') {
            steps {
                script {
                    def scannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'

                    withSonarQubeEnv('sonar') {
                        sh "${scannerHome}/bin/sonar-scanner"
                        sh 'ls'
                    }
                }
            }
        }
        stage('build image') {
            steps {
                sh 'docker build -t mygo:latest -f Dockerfile-main .'
            }
        }
        stage('trivy scan') {
            steps {
                script {
                         // sh 'docker build -t mygo:latest -f Dockerfile-main .'
                         // sh 'docker run -u root -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 0 --format json --output test.json'
                         def image = docker.image('aquasec/trivy:latest')
                         image.inside("--entrypoint '' -v /var/run/docker.sock:/var/run/docker.sock -u root") {
                             sh 'trivy --version'
                             sh 'trivy image mygo:latest --format cyclonedx -o trivy-report.json '
                             sh 'trivy sbom trivy-report.json --format template --template "@/contrib/html.tpl" -o trivy-report.html --severity MEDIUM,HIGH,CRITICAL '
                             //sh 'ls -la /usr/local/bin/trivy/ '
                             //sh 'find / -name html.tpl -type f'
                         }                     
                    // sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.49.1 image python:3.4-alpine'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
        stage('zap scan') {
            steps {
                script {
                    def zap = docker.image('owasp/zap2docker-stable:latest')
                    zap.inside('--entrypoint \'\' ') {
                        // sh 'zap-full-scan.py -t "https://" -r zap-report.html || true'
                    }
                }
            }
        }
    }
    
    post {
        success {
            archiveArtifacts allowEmptyArchive: true, artifacts: 'trivy-report.html'
            archiveArtifacts allowEmptyArchive: true, artifacts: 'trivy-report.json'
            // archiveArtifacts allowEmptyArchive: true, artifacts: 'zap-report.json'
            echo 'Build success!!!'
        }
    }
}
