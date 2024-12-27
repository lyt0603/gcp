# !/bin/sh

# 기본 결과값
result=0

# /etc/passwd에서 ftp 계정 검색 및 쉘 확인
ftp_account_shell=$(cat /etc/passwd | awk -F':' '$1 == "ftp" {print $NF}')

if [ -n "$ftp_account_shell" ]; then
    if [ "$ftp_account_shell" = "/sbin/nologin" ] || [ "$ftp_account_shell" = "/usr/sbin/nologin" ] || [ "$ftp_account_shell" = "/bin/false" ]; then
        echo "ftp 계정의 쉘이 올바르게 설정되어 있습니다: $ftp_account_shell"
        result=0
    else
        echo "ftp 계정의 쉘이 올바르게 설정되지 않았습니다: $ftp_account_shell"
        result=1
    fi
else
    echo "ftp 계정이 /etc/passwd에 존재하지 않습니다."
    result=0
fi

# 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "ftp 계정의 쉘 설정을 확인하고 /bin/false 또는 /sbin/nologin, 또는 /usr/sbin/nologin으로 설정해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.26 ftp 계정 shell 제한"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi