pipeline {
    agent any

    stages {
        stage('Build & Unit Test') {
            steps {
                echo 'Building UPI settlement gateway...'
                sh 'cat gateway.conf'
                // Simple unit test: config must enable the settlement core
                sh 'grep -q "SETTLEMENT_CORE=ACTIVE" gateway.conf && echo "Unit test PASSED"'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t fintech-gateway:v1.0 .'
                sh 'docker images | grep fintech-gateway'
            }
        }

        stage('Cluster Deploy') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl get all -l tier=payment'
            }
        }
    }

    post {
        success { echo 'Pipeline completed: Payment gateway deployed.' }
        failure { echo 'Pipeline failed. Check stage logs.' }
    }
}
