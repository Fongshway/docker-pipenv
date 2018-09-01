def dockerComposeTeardown() {
    sh("""
        docker-compose down  || echo "Docker compose down failed"
    """)
}

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
        stage('Setup Tests') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh('''
                        docker-compose up -d
                        sleep 10
                        docker exec pipenv bash -c "pipenv install pytest testinfra"
                    ''')
                }
            }
            post {
                failure {
                    dockerComposeTeardown()
                }
            }
        }
        stage("Test Docker Image") {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh('''
                        docker exec pipenv bash -c "pytest -v"
                    ''')
                }
            }
            post {
                failure {
                    dockerComposeTeardown()
                }
            }
        }
        stage('Tests Teardown') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    dockerComposeTeardown()
                }
            }
        }
        stage("Push Image to DockerHub") {
            when {
                branch "master"
            }
            steps {
                withDockerRegistry([credentialsId: "docker-hub-credentials", url: "https://registry.hub.docker.com/fongshway/pipenv"]) {
                  sh "docker push fongshway/pipenv:master"
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
