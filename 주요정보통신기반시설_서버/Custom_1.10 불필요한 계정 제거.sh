# !/bin/sh

# 기본 결과값
result=0

# /etc/passwd 파일에서 특정 계정 검색
specific_accounts=$(cat /etc/passwd | egrep "lp|uucp|nuucp")

if [ -n "$specific_accounts" ]; then
    echo "다음 계정이 /etc/passwd 파일에 존재합니다:"
    echo "----------------------------------------"
    echo "$specific_accounts"
    echo "----------------------------------------"
    result=1
else
    echo "/etc/passwd 파일에서 'lp', 'uucp', 'nuucp' 계정이 발견되지 않았습니다."
fi

# /etc/passwd 파일의 전체 내용 출력
echo "/etc/passwd 파일의 전체 내용:"
echo "----------------------------------------"
cat /etc/passwd
echo "----------------------------------------"

# 결과 확인 및 종료
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "불필요한 계정'lp' 또는 'uucp' 또는 'nuucp' 가 존재합니다."
    echo "계정의 리스트를 확인 후 불필요한 계정을 제거해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.10 불필요한 계정 제거"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi