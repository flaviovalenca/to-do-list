pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t todo-list-app .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh '''
                            echo "$DOCKERHUB_PASS" | docker login --username "$DOCKERHUB_USER" --password-stdin
                            docker tag todo-list-app "$DOCKERHUB_USER/todo-list-app:latest"
                            docker push "$DOCKERHUB_USER/todo-list-app:latest"
                        '''
                    }
                }
            }
        }

        stage('Deploy to Development') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh '''
                            echo "$DOCKERHUB_PASS" | docker login --username "$DOCKERHUB_USER" --password-stdin
                            docker rm -f todo-list-dev || true
                            docker pull "$DOCKERHUB_USER/todo-list-app:latest"
                            docker run -d -p 8001:8000 --name todo-list-dev "$DOCKERHUB_USER/todo-list-app:latest"
                        '''
                    }
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    input(message: 'Deploy to Production?', ok: 'Deploy',
                        submitterParameter: 'submitter')
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh '''
                            echo "$DOCKERHUB_PASS" | docker login --username "$DOCKERHUB_USER" --password-stdin
                            docker pull "$DOCKERHUB_USER/todo-list-app:latest"
                            docker rm -f todo-list-app-prod || true
                            docker run -d --name todo-list-app-prod -p 8000:8000 "$DOCKERHUB_USER/todo-list-app:latest"
                        '''
                    }
                }
            }
        }
    }
}
