pipeline {
  agent { label "nodejs" }
  environment {
      PATH = "/usr/local/sbin:/usr/local/bin:$PATH"
  }
  stages {
    stage("Install dependencies") {
        steps {
            sh("printenv")
            sh("/usr/local/bin/npm install .")
        }
    }
    stage("Build") {
        steps {
            sh("npm run-script build")
        }
    }
  }
}
