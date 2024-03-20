def changedFiles = []
def buildList = []
pipeline {
    agent any
    tools {
        go 'go'
        nodejs 'node'
        // dockerTool 'docker'
        // 'hudson.plugins.sonar.SonarRunnerInstallation' 'sonar'
    }   
    environment {
        MODULE = 'mod1,mod2,mod3'
    }
    stages {
        stage('check') {
            steps {
                script {
                def previousBuild = currentBuild.getPreviousBuild()
                while (previousBuild.result == 'FAILURE') {
                    for (changeLogSet in previousBuild.changeSets) {
                    for (entry in changeLogSet.getItems()) { 
                        for (file in entry.getAffectedFiles()) {
                            changedFiles.add(file.getPath())
                        }
                    }
                    }
                    previousBuild = previousBuild.getPreviousBuild()
                }
                for (changeLogSet in currentBuild.changeSets) {
                    for (entry in changeLogSet.getItems()) { 
                        for (file in entry.getAffectedFiles()) {
                            changedFiles.add(file.getPath()) 
                        }
                    }
                }
                }
            }
        }
        stage('Build apap') {
            steps {
                script {
                    echo "module"
                    // for (thing in env.MODULE.split(',')) {
                    //     echo thing
                    // }
                    buildList = makeList(changedFiles)
                    if (buildList.size() != 0) {
                        echo 'buildList'
                        for (a in buildList) {
                            echo a
                        }
                    }
                    else {
                        currentBuild.result = 'ABORTED'
                        error('No module to be build. Jenkins will stop.')
                    }
                }
            }
        }
        stage('Build app') {
            steps {
                script {
                for (elem in buildList) {
                    sh "go build -o cmd/${elem} cmd/${elem}/main.go"
                }
                }
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
                script {
                for (element in buildList) {
                    sh "docker build -t ${element}:latest -p 8180:8080 --build-arg target=${element} -f Dockerfile-main ."
                }
                sh 'docker images'
                }
            }
        }
        stage('trivy scan') {
            steps {
                script {
                         // sh 'docker build -t mygo:latest -f Dockerfile-main .'
                         // sh 'docker run -u root -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 0 --format json --output test.json'
                         def image = docker.image('aquasec/trivy:latest')
                         image.inside("--entrypoint ''  -v /var/run/docker.sock:/var/run/docker.sock -u root") {
                            sh 'trivy --version'
                            for (int i = 0 ; i < buildList.size() ; i ++) {
                                echo "scanning ${buildList[i]}"
                                sh "trivy image ${buildList[i]}:latest --format cyclonedx -o ${buildList[i]}-trivy-report.json "
                                sh "trivy sbom ${buildList[i]}-trivy-report.json --format template --template '@/contrib/html.tpl' -o ${buildList[i]}-trivy-report.html --severity MEDIUM,HIGH,CRITICAL "
                            }
                             //sh 'ls -la /usr/local/bin/trivy/ '
                             //sh 'find / -name html.tpl -type f'
                         }                     
                    // sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.49.1 image python:3.4-alpine'
                }
            }
        }
    //     stage('Deploy') {
    //         steps {
    //             echo 'Deploying...'
    //         }
    //     }
    //     stage('zap scan') {
    //         steps {
    //             script {
    //                 def zap = docker.image('owasp/zap2docker-stable:latest')
    //                 zap.inside('--entrypoint \'\' ') {
    //                     // sh 'zap-full-scan.py -t "https://" -r zap-report.html || true'
    //                 }
    //             }
    //         }
    //     }
    // }
    }
    post {
        success {
            script {
            for (element in buildList) {
                archiveArtifacts allowEmptyArchive: true, artifacts: "${element}-trivy-report.html"
                archiveArtifacts allowEmptyArchive: true, artifacts: "${element}-trivy-report.json"
            }
            }
            // archiveArtifacts allowEmptyArchive: true, artifacts: 'zap-report.json'
            echo 'Build success!!!'
        }
    }
}


def makeList(ArrayList list) {
    def newList = []
    def moduleList = env.MODULE.split(',')
    def ListString = []
    for (element in list) {
        ListString = element.split('/')
        for (int i = 0; i < ListString.size() ; i++) {
            if ((moduleList.find {it == ListString[i]}) != null) {
                if ((newList.find {it == ListString[i]} == null)) {
                    newList.add(ListString[i])
                }
            }
        }
    }
    return newList
}
