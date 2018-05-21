pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    environment {
        DOCKER_IMAGE = "fongshway/pipenv"
    }
    stages {
        stage("Build image") {
            steps {
                sh "docker build . -t $DOCKER_IMAGE:${BRANCH_NAME}"
            }
        }
        stage("Test image") {
            steps {
                sh "docker run -v /var/run/docker.sock:/var/run/docker.sock --name pytest fongshway/pytest pytest --junitxml=/app/test_report.xml"
            }
        }
        stage("Push image") {
            steps {
                withDockerRegistry([credentialsId: "docker-hub-credentials", url: "https://registry.hub.docker.com/$DOCKER_IMAGE"]) {
                  sh "docker push $DOCKER_IMAGE:${BRANCH_NAME}"
                }
            }
        }
    }
    post {
        always {
            sh "docker cp pytest:/app/test_report.xml ."
            junit 'test_report.xml'
        }
    }
}
