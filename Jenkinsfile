def changedFiles = []
def buildList = []
def randomNumber = generateRandomNumber(100)
def date = ""
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
                def now = new Date()
                date = now.format("yyMMddHHmm", TimeZone.getTimeZone('UTC'))
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
                    sh "docker build -t imax2600/${element}:${date} --build-arg target=${element} -f Dockerfile-main ."
                }
                sh 'docker images'
                }
            }
        }
        // stage('trivy scan') {
        //     steps {
        //         script {
        //                  // sh 'docker build -t mygo:latest -f Dockerfile-main .'
        //                  // sh 'docker run -u root -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/MyGo/Caches/:/root/.cache/ aquasec/trivy image mygo:latest --exit-code 0 --format json --output test.json'
        //                  def image = docker.image('aquasec/trivy:latest')
        //                  image.inside("--entrypoint ''  -v /var/run/docker.sock:/var/run/docker.sock -u root") {
        //                     sh 'trivy --version'
        //                     for (int i = 0 ; i < buildList.size() ; i ++) {
        //                         echo "scanning ${buildList[i]}"
        //                         sh "trivy image imax2600/${buildList[i]}:${date} --format cyclonedx -o ${buildList[i]}-trivy-report.json "
        //                         sh "trivy sbom ${buildList[i]}-trivy-report.json --format template --template '@/contrib/html.tpl' -o ${buildList[i]}-trivy-report.html --severity MEDIUM,HIGH,CRITICAL "
        //                     }
        //                      //sh 'ls -la /usr/local/bin/trivy/ '
        //                      //sh 'find / -name html.tpl -type f'
        //                  }                     
        //             // sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.49.1 image python:3.4-alpine'
        //         }
        //     }
        // }
        stage('deploy') {
            steps {
                script {
                withCredentials([string(credentialsId: 'docker-pass', variable: 'DK_PASS')]) {
                    sh "docker login -u imax2600 -p $DK_PASS"
                    for (module in buildList) {
                    sh "docker push imax2600/${module}:${date}"
                    }
                    sh "docker logout "
                }
                sh 'docker build -t helmimage:latest -f Dockerfile-helm .'
                // withKubeConfig( credentialsId: 'testK8s',  serverUrl: 'https://192.168.65.3:6443') {
                    def helm = docker.image('helmimage:latest')
                    helm.inside{
                        sh 'ls'
                    }
                    // helm.inside ("-u root") {
                    //     withKubeConfig( credentialsId: 'testK8s',  serverUrl: 'https://192.168.0.227:49440') {
                    //     script {
                    //         for (module in buildList) {
                    //             sh "helm upgrade --install ${module} --values deploychart/values/${module}-values.yaml deploychart --set container.image=imax2600/${module}:${date}"
                    //         }
                    //     }    
                    //     // sh 'kubectl config view'
                    //     // sh 'helm repo add demo-frontend https://yushiwho.github.io/charts'
                    //     // sh 'helm repo update'
                    //     // sh 'helm install my-release demo-frontend/demo-frontend --namespace demo-frontend'
                    //     // sh 'helm repo remove demo-frontend'
                    //     }
                    // }
                    // sh 'kubectl apply -f service.yaml'
                    // sh 'kubectl apply -f deployment.yaml'
                    // sh 'kubectl rollout restart deployment test-app'
                // }
                }
            }
        }
    //     stage('Deploy') {
    //         steps {
    //             echo 'Deploying...'
    //         }
    //     }

    //  stage('zap scan') {
    //          steps {
    //              script {
    //                 sh 'mkdir zap'
    //                 sh 'docker run -u root -v zap:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py -t http://192.168.0.227:3000 -r zap-report1.html -I'
    //                 // sh 'docker run -u root -v zap:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py -t http://192.168.0.227:3001 -r zap-report2.html -I'
    //                 // sh 'docker run -u root -v zap:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py -t http://192.168.0.227:3002 -r zap-report3.html -I'
    //                 // def zap = docker.image('owasp/zap2docker-stable:latest')
    //                 // zap.inside('--entrypoint \'\' -v zap:/zap/wrk -u root') {
    //                 //      sh 'zap-full-scan.py -t "http://192.168.0.227:3000" -r zap-report1.html || true'
    //                 //      sh 'zap-full-scan.py -t "http://192.168.0.227:3001" -r zap-report2.html || true'
    //                 //      sh 'zap-full-scan.py -t "http://192.168.0.227:3002" -r zap-report3.html || true'
    //                 // }
    //              }
    //          }
    // }

    }
    //}
    post {
        success {
            script {
            for (element in buildList) {
                archiveArtifacts allowEmptyArchive: true, artifacts: "${element}-trivy-report.html"
                archiveArtifacts allowEmptyArchive: true, artifacts: "${element}-trivy-report.json"
            }
            }
            archiveArtifacts allowEmptyArchive: true, artifacts: "zap/zap-report1.html"
            archiveArtifacts allowEmptyArchive: true, artifacts: "zap/zap-report2.html"
            archiveArtifacts allowEmptyArchive: true, artifacts: "zap/zap-report3.html"
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
def generateRandomNumber(int max) {
    return Math.abs(new Random().nextInt() % max)
}
