pipeline {
  agent { label "nodejs" }
  environment {
      PATH = "/usr/local/sbin:/usr/local/bin:$PATH"
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
          sh("bash $WORKSPACE/build.sh -e staging")
          sh("bash $WORKSPACE/build.sh -e production")
        }
    }
  }
}
