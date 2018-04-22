node {
    def app

    stage('Clone repository') {
        // Clone the repository to the workspace
        checkout scm
    }

    stage('Build image') {
        // Build the actual image. Synonymous to docker build on the command line.
        app = docker.build("fongshway/pipenv")
    }

    stage('Test image') {
        // Ideally, we would run a test framework against our image.
        app.inside {
            sh 'echo "Tests go here"'
        }
    }

    stage('Push image') {
        /* Login into the registry. Defaults to dockerhub registry
         * See https://issues.jenkins-ci.org/browse/JENKINS-38018  */
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
            sh "docker login --password=${PASSWORD} --username=${USERNAME}"
        }

        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        app.push("${env.BUILD_NUMBER}")
        app.push("latest")
    }
}
