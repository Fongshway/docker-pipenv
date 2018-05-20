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
                sh "docker run -v /var/run/docker.sock:/var/run/docker.sock --name pytest fongshway/pytest pytest --junitxml=/app/test_report.xml"
                sh "docker cp pytest:/app/test_report.xml ."
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
