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
          sh("sh build.sh -e staging")
          sh("sh build.sh -e production")
        }
    }
  }
}
