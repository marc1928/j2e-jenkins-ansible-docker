pipeline {
    agent any

    environment {
        CT_Name = "asp-j2e"
        REGISTRY = "marcbassi"
        IMAGE = "appjsp-${env.BUILD_ID}"
        TAG = "${env.BUILD_ID}"
        PORT = 8002
    }

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                script {
                    img = docker.build("${REGISTRY}/${IMAGE}:${TAG}", ".")
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'registry_docker', url: 'https://index.docker.io/v1/') {
                        img.push()
                    }
                }
            }
        }

        stage('Ansible') {
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'Ansible',
                                transfers: [
                                    sshTransfer(
                                        cleanRemote: false,
                                        excludes: '',
                                        execCommand: '''cd ansfolder;
docker rm -f ${CT_Name} || true;                                     
ansible-playbook -i hosts.yaml play.yaml -e \\
    "container_name=${CT_Name} image_name=${REGISTRY}/${IMAGE} image_tag=${TAG} port=${PORT}";''',
                                        execTimeout: 120000,
                                        flatten: false,
                                        makeEmptyDirs: false,
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+',
                                        remoteDirectory: 'ansfolder',
                                        remoteDirectorySDF: false,
                                        removePrefix: 'ansible',
                                        sourceFiles: 'play.yaml, hosts.yaml'
                                    )
                                ],
                                usePromotionTimestamp: false,
                                useWorkspaceInPromotion: false,
                                verbose: false
                            )
                        ]
                    )
                }
            }
        }
        stage('Build image') {
            steps {
                script {
                    echo "Accédez à l'application: http://172.16.15.13:${port}/appjsp "
                }
            }
        }        
    }
}
