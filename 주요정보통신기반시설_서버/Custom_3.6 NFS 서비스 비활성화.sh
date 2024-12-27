# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 NFS 관련 프로세스 검사
nfs_process=$(ps -ef | egrep "nfs|statd|lockd" | grep -vE "grep|--color|egrep|kblockd|kworker")

if [ -n "$nfs_process" ]; then
    echo "NFS 프로세스가 실행 중입니다."
    echo "$nfs_process"
    result=1
else
    echo "NFS 프로세스가 실행되고 있지 않습니다."
fi

# [2] inetadm 명령어를 통해 NFS 관련 서비스 검사 (Solaris 환경)
if command -v inetadm >/dev/null 2>&1; then
    inetadm_output=$(inetadm | egrep "nfs|statd|lockd" 2>/dev/null)

    if [ -n "$inetadm_output" ]; then
        echo "inetadm 에서 NFS 서비스가 활성화되어 있습니다:"
        echo "$inetadm_output"
        result=1
    else
        echo "inetadm 에서 NFS 관련 서비스가 활성화되어 있지 않습니다."
    fi
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo 'ps -ef | egrep "nfs|statd|lockd", inetadm | egrep "nfs|statd|lockd"로 NFS 관련 프로세스를 확인해주세요.'
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.6 NFS 서비스 비활성"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi