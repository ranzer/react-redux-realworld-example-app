pipeline {
    agent { label "nodejs" }
    environment {
        PATH = "/usr/local/sbin:/usr/local/bin:$PATH"
        ARTIFACT_NAME = "${GIT_BRANCH}".substring("${GIT_BRANCH}".lastIndexOf('/') + 1) + "${BUILD_NUMBER}"
    }
    stages {
        stage("Install dependencies") {
            steps {
                sh("printenv")
                sh("npm install")
            }
        }
        stage("Build") {
            steps {
                dir("${env.WORKSPACE}") {
                    sh("echo ARTIFACT_NAME: ${ARTIFACT_NAME}")
                    sh("pwd")
                    sh("bash build.sh -e staging")
                    sh("bash build.sh -e production")
                    sh("tar -cvzf ${ARTIFACT_NAME}.tar staging production")
                    sh("gzip ${ARTIFACT_NAME}.tar")
                }
            }
        }
    }
}
