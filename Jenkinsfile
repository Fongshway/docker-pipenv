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
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        try {
                            sh('''
                                docker-compose -f docker-compose.test.yml pull
                                docker-compose -f docker-compose.test.yml up -d
                            ''')
                        } finally {
                            sh('''
                                docker cp pytest:/app/test_report.xml .
                                docker-compose -f docker-compose.test.yml down || echo "Docker compose down failed"
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
            junit 'test_report.xml'
            sh "docker system prune -f"
        }
    }
}
