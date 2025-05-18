pipeline {
    agent any

    environment {
        REGISTRY = 'marcbassi'
        IMAGE = 'appjsp'
        TAG = "${env.BUILD_ID}"
        PORT = 8011
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
                   sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''cd ansfolder;
ansible-playbook -i hosts.yaml play.yaml;''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: 'ansfolder', remoteDirectorySDF: false, removePrefix: 'ansible', sourceFiles: 'play.yaml, hosts.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                }
            }
        }
    }
}
