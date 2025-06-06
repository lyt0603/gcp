podTemplate(label: 'test-scan', containers: [
    // gcloud 컨테이너 정의 (bash 사용)
    containerTemplate(name: 'gcloud', image: 'google/cloud-sdk:alpine', ttyEnabled: true, alwaysPullImage: true)

], 
    volumes: [
        hostPathVolume(mountPath: "/var/run/docker.sock", hostPath: "/var/run/docker.sock")
    ]
) 
{
    node('test-scan') {
        stage('Docker') {
            container('gcloud') {  // 컨테이너 이름 'gcloud'로 사용
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
        stage ('Prisma Cloud scan') { 
            try {   
                prismaCloudScanImage ca: '',
                cert: '',
                containerized: true,
                image: 'asia-northeast3-docker.pkg.dev/flash-physics-368407/lyt-test/crypto-app:latest',
                dockerAddress: 'unix:///var/run/docker.sock',
                project: '',
                ignoreImageBuildTime: true,
                key: '',
                logLevel: 'info',
                podmanPath: '',
                resultsFile: 'prisma-cloud-scan-results.json'
            } catch (all) {
                currentBuild.result = 'FAILURE'
            }
        }
        stage ('Prisma Cloud publish') { 
            prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
        }
    }
}
