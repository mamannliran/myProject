pipeline {
  agent any
  stages {
    stage("Set Up") {
      steps {
        echo "Logging into the private AWS Elastic Container Registry"
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Build Test Image") {
      steps {
        echo 'Start building the project docker image for tests'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Run Unit Tests") {
      steps {
        echo 'Run unit tests in the docker image'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Run Integration Tests") {
      steps {
        echo 'Run Integration tests in the docker image'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Build Staging Image") {
      steps {
        echo 'Build the staging image for more tests'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Run Load Balancing tests / Security Checks") {
      steps {
        echo 'Run load balancing tests and security checks'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Deploy to Fixed Server") {
      steps {
        echo 'Deploy release to production'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
    stage("Clean Up") {
      steps {
        echo 'Clean up local docker images'
        script {
          sh """
          echo "Hello World"
          """
        }
      }
    }
  }
}