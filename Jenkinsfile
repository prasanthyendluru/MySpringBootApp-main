pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        DOCKER_IMAGE       = "prasanthyendluru/simple-hello-prasanth"
        DOCKER_CREDENTIALS = "docker-prasanth"
        AWS_CREDS          = "aws-cred"
        AWS_REGION         = "eu-west-2"
        EKS_CLUSTER        = "devops-nation-cluster"  // Replace with your cluster name
        KUBE_NAMESPACE     = "prasanth-namespace"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/prasanthyendluru/MySpringBootApp-main.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                    docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDENTIALS,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: "${AWS_CREDS}"]]) {
                    sh '''
                        aws configure set default.region "$AWS_REGION"
                        aws eks update-kubeconfig --region "$AWS_REGION" --name "$EKS_CLUSTER"

                        kubectl get ns "$KUBE_NAMESPACE" >/dev/null 2>&1 || kubectl create ns "$KUBE_NAMESPACE"

                        kubectl apply -n "$KUBE_NAMESPACE" -f k8s/deployment.yaml
                        kubectl apply -n "$KUBE_NAMESPACE" -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
