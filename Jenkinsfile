pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    stages {
        stage('Build image') {
            steps {
                sh "docker build . -t fongshway/pipenv:${BRANCH_NAME}"
            }
        }
        stage('Test image') {
            steps {
                sh "echo 'Tests go here'"
            }
        }
        stage('Push image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://registry.hub.docker.com/fongshway/pipenv']) {
                  sh "docker push fongshway/pipenv:${BRANCH_NAME}"
                }
            }
        }
    }
    post {
        always {
            junit 'test_report.xml'
        }
    }
}
