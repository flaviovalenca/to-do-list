pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    configFileProvider([configFile(fileId: 'fd0922d5-c25c-4529-8537-0419ddc85962', targetLocation: '.env')]) {
                        sh '''
                            docker build --progress=plain -t todo-list-app . &
                            build_pid=$!
                            while kill -0 "$build_pid" 2>/dev/null; do
                                echo "Docker build ainda em execução..."
                                sleep 30
                            done
                            wait "$build_pid"
                        '''
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh '''
                            printf '%s' "$DOCKERHUB_PASS" | docker login --username "$DOCKERHUB_USER" --password-stdin
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
                            printf '%s' "$DOCKERHUB_PASS" | docker login --username "$DOCKERHUB_USER" --password-stdin
                            docker rm -f todo-list-dev || true
                            docker pull "$DOCKERHUB_USER/todo-list-app:latest"
                            docker run -d -p 8001:8000 --name todo-list-dev "$DOCKERHUB_USER/todo-list-app:latest"
                        '''
                    }
                }
            }
        }

    }
}

