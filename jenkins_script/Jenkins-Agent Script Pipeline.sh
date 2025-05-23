podTemplate(label: 'test-scan', containers: [
    containerTemplate(name: 'gcloud', image: 'google/cloud-sdk:alpine', command: 'cat', ttyEnabled: true, alwaysPullImage: true, resourceRequestCpu: '10m')
], 
volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]
) {
    node('test-scan') {
        // 1. Scan 할 Image Pull
        stage('Docker') {
            container('gcloud') {  
                withCredentials([file(credentialsId: 'GKE-Secret', variable: 'GOOGLE_AUTH')]) {
                    sh '''
                        gcloud auth activate-service-account --key-file="${GOOGLE_AUTH}"
                        gcloud --quiet auth configure-docker
                        gcloud --quiet auth configure-docker asia-northeast3-docker.pkg.dev
                        docker pull asia-northeast3-docker.pkg.dev/flash-physics-368407/lyt-test/crypto-app:latest
                        docker images
                    '''
                }
            }
        }
            
            // 2. Twistcli Pull & Install 후 Image Scan
            stage('twistcli Scan') {
                withCredentials([string(credentialsId: 'PRISMA_USER', variable: 'prismauser'), string(credentialsId: 'PRISMA_PWD', variable: 'prismapwd'), string(credentialsId: 'TWISTCLI_URL', variable: 'twistcliurl'), file(credentialsId: 'GKE-Secret', variable: 'GOOGLE_AUTH')]) {
                    container('gcloud') {
                        sh '''
                            gcloud auth activate-service-account --key-file="${GOOGLE_AUTH}"
                            gcloud --quiet auth configure-docker asia-northeast3-docker.pkg.dev

                            docker run --rm \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            asia-northeast3-docker.pkg.dev/flash-physics-368407/twistlock2/twistlock:suc \
                            images scan --address ${twistcliurl} \
                            --user ${prismauser} --password ${prismapwd} \
                            --details asia-northeast3-docker.pkg.dev/flash-physics-368407/lyt-test/crypto-app:latest
                        '''
                    }
                }
            }
    }
}
