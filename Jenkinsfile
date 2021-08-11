pipeline {
    agent { label "nodejs" }
    environment {
        PATH = "/usr/local/sbin:/usr/local/bin:$PATH"
        GIT_BRANCH_SHORT_NAME = "${GIT_BRANCH}".substring("${GIT_BRANCH}".lastIndexOf('/') + 1)
        ARTIFACT_NAME = "${GIT_BRANCH_SHORT_NAME}${BUILD_NUMBER}"
        AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY}"
        AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_KEY}"
        AWS_DEFAULT_REGION = "us-east-1"
        ARTIFACTS_S3_BUCKET = "s3://${params.ARTIFACTS_S3_BUCKET}"
        APP_S3_BUCKET = "s3://${params.APP_S3_BUCKET}"
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
                    sh("bash build.bash -e staging")
                    sh("bash build.bash -e production")
                    sh("tar -cvzf ${ARTIFACT_NAME}.tar staging production")
                    sh("gzip ${ARTIFACT_NAME}.tar")
                }
            }
        }
        stage("Deploy artifacts to S3 bucket") {
            steps {
                withAWS(credentials: "MOP_AWS_CREDENTIALS") {
                    sh("aws s3 cp ${ARTIFACT_NAME}.tar.gz ${ARTIFACTS_S3_BUCKET}")
                }
            }
        }
        stage("Deploy staging application to S3 bucket") {
            steps {
                withAWS(credentials: "MOP_AWS_CREDENTIALS") {
                    sh("aws s3 cp staging/ ${APP_S3_BUCKET} --recursive")
                }
            }
        }
    }
    post {
        cleanup {
            deleteDir()
            dir("${workspace}@tmp") {
                deleteDir()
            }
            dir("${workspace}@script") {
                deleteDir()
            }
        }
    }
}
