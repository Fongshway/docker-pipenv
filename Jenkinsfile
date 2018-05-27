pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    environment {
        DOCKER_IMAGE = "fongshway/pipenv"
        COMPOSE_FILE = "docker-compose.test.yml"
        TEST_CONTAINER_NAME = "pipenv_pytest"
    }
    stages {
        stage("Build image") {
            steps {
                sh "docker build --no-cache --force-rm . --tag $DOCKER_IMAGE:dev"
            }
        }
        stage("Test image") {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        try {
                            sh('''
                                docker-compose -f $COMPOSE_FILE up -d --build --force-recreate
                                sleep 10
                                docker exec $TEST_CONTAINER_NAME bash -c "pytest -v"
                                docker exec $TEST_CONTAINER_NAME bash -c "pylint tests"
                            ''')
                        } finally {
                            sh('''
                                docker-compose -f $COMPOSE_FILE down --remove-orphans || echo "Docker compose down failed"
                            ''')
                        }
                    }
                }
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
            sh "docker system prune -f"
        }
    }
}
