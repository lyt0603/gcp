# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 NFS 관련 프로세스 검사
nfs_process=$(ps -ef | egrep "nfs|statd|lockd" | grep -vE "grep|--color|egrep|kblockd|kworker")

if [ -n "$nfs_process" ]; then
    echo "NFS 프로세스가 실행 중입니다."
    result=1
else
    echo "NFS 프로세스가 실행되고 있지 않습니다."
fi

# [2] inetadm 명령어를 통해 NFS 관련 서비스 검사 (Solaris 환경)
if command -v inetadm >/dev/null 2>&1; then
    inetadm_output=$(inetadm | egrep "nfs|statd|lockd" 2>/dev/null)
    if [ -n "$inetadm_output" ]; then
        echo "inetadm 에서 NFS 서비스가 활성화 되어 있습니다."
        result=1
    else
        echo "inetadm 에서 NFS 관련 서비스가 활성화 되어 있지 않습니다."
    fi
fi

# [3] NFS 설정 파일 검사 (항상 수행, 주석과 빈 줄 제외)
files="/etc/dfs/dfstab /etc/dfs/sharetab /etc/exports"

for file in $files; do
    if [ -f "$file" ]; then
        # 주석이 아닌 라인과 빈 줄을 제외한 내용 검사
        file_content=$(grep -vE '^[[:space:]]*#' "$file" | grep -vE '^[[:space:]]*$')
        if [ -n "$file_content" ]; then
            echo "$file 파일 내용입니다."
            echo "$file_content"
            result=1
        else
            echo "$file 파일이 존재하지만 내용이 없거나 주석만 존재합니다."
        fi
    else
        echo "$file 파일이 존재하지 않습니다."
    fi
done

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/dfs/dfstab, /etc/dfs/sharetab, /etc/exports 파일 내용을 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.7 NFS 접근 통제"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi