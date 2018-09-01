pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '50'))
    }
    stages {
        stage("Build Docker Image") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    sh('''
                        docker build --no-cache --force-rm . --label pipenv --tag fongshway/pipenv:master
                    ''')
                }
            }
        }
        stage("Push Image to DockerHub") {
            when {
                branch "master"
            }
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    withDockerRegistry([credentialsId: "docker-hub-credentials", url: "https://registry.hub.docker.com/fongshway/pipenv"]) {
                      sh "docker push fongshway/pipenv:master"
                    }
                }
            }
        }
    }
    post {
        always {
            sh "docker system prune -f"
        }
    }
}
