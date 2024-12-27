# !/bin/sh

# /etc/passwd 파일 확인
if [ ! -e "/etc/passwd" ]; then
    echo "/etc/passwd 파일이 존재하지 않습니다. 경로를 확인해주세요."
    exit 1
fi

# root 계정을 제외한 UID 값이 0인 계정 확인
uid_0_accounts=$(awk -F':' '$3 == 0 && $1 != "root" {print $0}' /etc/passwd)

if [ -n "$uid_0_accounts" ]; then
    echo "root 외에 UID 값이 0으로 설정된 계정이 발견되었습니다:"
    echo "----------------------------------------"
    echo "$uid_0_accounts"
    echo "----------------------------------------"
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "해당 계정의 UID 값이 0 입니다."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.5 root 이외의 UID가 '0' 금지"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "root 외에 UID 값이 0으로 설정된 계정이 없습니다. 조건이 충족되었습니다. exit 0"
    exit 0
fi