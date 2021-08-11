pipeline {
    agent { label "nodejs" }
    environment {
        PATH = "/usr/local/sbin:/usr/local/bin:$PATH"
        GIT_BRANCH_SHORT_NAME = "${GIT_BRANCH}".substring("${GIT_BRANCH}".lastIndexOf('/') + 1)
        ARTIFACT_NAME = "${GIT_BRANCH_SHORT_NAME}${BUILD_NUMBER}"
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
                    sh("bash build.bash -e staging")
                    sh("bash build.bash -e production")
                    sh("tar -cvzf ${ARTIFACT_NAME}.tar staging production")
                    sh("gzip ${ARTIFACT_NAME}.tar")
                }
            }
        }
    }
}
