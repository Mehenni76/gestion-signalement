pipeline {
    agent any
    
    tools {
        maven 'M3'
    }
    
    stages {
        stage('Cleaning workspace'){
            steps {
                sh 'echo "---=--- Cleaning Stage ---=---"'
                sh 'mvn clean'
                script {
                    try {
                        sh 'docker stop myboot && docker rm myboot'
                    } catch (Exception e) {
                        sh 'echo "---=--- No container to remove ---=---"'
                    }                    
                }
            }
        }
        stage('Checkout'){
            steps {
                sh 'echo "---=--- Checkout ---=---"'
                git branch: 'main', url: 'https://github.com/Mehenni76/gestion-signalement.git'
            }
        }
        stage('Compile'){
            steps {
                sh 'echo "---=--- Checkout ---=---"'
                sh 'mvn compile'
            }
        }
        stage('Test'){
            steps {
                sh 'echo "---=--- Test ---=---"'
                sh 'mvn test'
            }
        }
        stage('Package'){
            steps {
                sh 'echo "---=--- Package ---=---"'
                sh 'mvn package -DskipTests'
            }
	 post {
            always {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        } 
        }
        stage('Docker'){
            steps {
                sh 'echo "---=--- Docker ---=---"'
                sh 'docker build -t mm167/myboot:1.0 .'
            }
        }
        stage('Deploy To Local'){
            steps {
                sh 'echo "---=--- Deploy To Aws ---=---"'
                sh 'docker run -d --name myboot -p 8180:8081 mm167/myboot:1.0'
            }
        }
    }
}