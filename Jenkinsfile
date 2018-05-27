pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    environment {
        DOCKER_IMAGE = "fongshway/pipenv"
        COMPOSE_FILE_LOC = "docker-compose.test.yml"
        TEST_CONTAINER_NAME = "pipenv_pytest"
        COMPOSE_PROJECT_NAME = "jenkinsbuild_${BUILD_TAG}"
        TEST_CONTAINER_REF = "${COMPOSE_PROJECT_NAME}_${TEST_CONTAINER_NAME}_1"
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
                                docker-compose -f docker-compose.test.yml -p $COMPOSE_PROJECT_NAME up -d --build --force-recreate
                                sleep 10
                                docker exec $TEST_CONTAINER_REF bash -c "pytest -v --junitxml=/app/test_report.xml"
                            ''')
                        } finally {
                            sh("docker cp $TEST_CONTAINER_REF:/app/test_report.xml .")
                            junit "test_report.xml"
                            sh('''
                                docker-compose -f docker-compose.test.yml -p $COMPOSE_PROJECT_NAME down --remove-orphans || echo "Docker compose down failed"
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
