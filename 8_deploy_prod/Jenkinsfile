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
                    withCredentials([usernamePassword(credentialsId: 'jenkins-dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh """
                            docker login -u '${DOCKERHUB_USER}' -p '${DOCKERHUB_PASS}'
                            docker tag todo-list-app ${DOCKERHUB_USER}/todo-list-app:latest
                            docker push ${DOCKERHUB_USER}/todo-list-app:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to Development') {
            steps {
                script {
                    sh """
                        docker rm -f todo-list-dev
                        docker run -d -p 8001:8000 --name todo-list-dev pcmadevops/todo-list-app:latest
                    """
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    def userInput = input(message: "Deploy to Production? (yes/no)", ok: 'Deploy',
                        submitterParameter: 'submitter')
                    if (userInput == 'yes') {
                        withCredentials([usernamePassword(credentialsId: 'jenkins-dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                            sh """
                                docker login -u '${DOCKERHUB_USER}' -p '${DOCKERHUB_PASS}'
                                docker pull ${DOCKERHUB_USER}/todo-list-app:latest 
                                docker rm -f todo-list-app-prod
                                docker run -d --name todo-list-app-prod -p 8000:8000 ${DOCKERHUB_USER}/todo-list-app:latest
                            """
                        }
                    } else {
                        currentBuild.result = 'ABORTED'
                        error('Deploy to production cancelled')
                    }
                }
            }
        }
    }
}
