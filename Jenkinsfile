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
                sh "docker build --no-cache --force-rm . --tag $DOCKER_IMAGE:dev"
            }
        }
        stage("Test image") {
            steps {
                sh "docker-compose -f docker-compose.test.yml pull"
                sh "docker-compose -f docker-compose.test.yml up"
            }
        }
        stage("Push dev image") {
            steps {
                withDockerRegistry([credentialsId: "docker-hub-credentials", url: "https://registry.hub.docker.com/$DOCKER_IMAGE"]) {
                  sh "docker push $DOCKER_IMAGE:dev"
                }
            }
        }
        stage("Push master image") {
            when {
                branch "master"
            }
            steps {
                sh "docker tag $DOCKER_IMAGE:dev $DOCKER_IMAGE:master"
                withDockerRegistry([credentialsId: "docker-hub-credentials", url: "https://registry.hub.docker.com/$DOCKER_IMAGE"]) {
                  sh "docker push $DOCKER_IMAGE:master"
                }
            }
        }
    }
    post {
        always {
            sh "docker cp pytest:/app/test_report.xml ."
            junit "test_report.xml"
            sh "docker-compose -f docker-compose.test.yml down"
            sh "docker system prune -f"
        }
    }
}
