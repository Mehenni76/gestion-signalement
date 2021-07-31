pipeline {
    agent any
    
    tools {
        maven 'M3'
    }
    
    stages {
        stage('Cleaning workspace'){
            steps {
                sh 'echo "---=--- Cleaning Stage ---=---"'
                script {
                    try {
                        sh 'docker stop gestion-signalement && docker rm gestion-signalement'
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
        stage('Clean'){
            steps {
                sh 'echo "---=--- clean ---=---"'
                sh 'mvn clean'
            }
        }
        stage('Compile'){
            steps {
                sh 'echo "---=--- Compile ---=---"'
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
    stage('SSH transfert') {
        steps {
            script {
                sshPublisher(publishers: [
                    sshPublisherDesc(configName: 'ec2-host', transfers:[
                        sshTransfer(
                          execCommand: '''
                                echo "-=- Cleaning project -=-"
                                sudo docker stop gestion-signalement  || true
                                sudo docker rm gestion-signalement || true
                                sudo docker rmi mdjadda/gestion-signalement:1.0 || true
                            '''
                        ),
                        sshTransfer(
                            sourceFiles:"target/gestion-signalement.jar",
                            removePrefix: "target",
                            remoteDirectory: "//home//ec2-user",
                            execCommand: "ls /home/ec2-user"
                        ),
                        sshTransfer(
                            sourceFiles:"Dockerfile",
                            removePrefix: "",
                            remoteDirectory: "//home//ec2-user",
                            execCommand: '''
                                cd //home//ec2-user;
                                sudo docker build -t mdjadda/gestion-signalement:1.0 .; 
                                sudo docker run -d --name gestion-signalement -p 8080:8080 mdjadda/gestion-signalement:1.0;
                            '''
                        )
                    ])
                ])                
            }
        }
    }
    }
}