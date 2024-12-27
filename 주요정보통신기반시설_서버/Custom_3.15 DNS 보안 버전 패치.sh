# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 named 프로세스 검사
named_process=$(ps -ef | grep "named" | grep -vE "grep|--color|egrep")

if [ -n "$named_process" ]; then
    echo "named 프로세스가 실행 중입니다."
    echo "$named_process"

    # named -v 명령 실행하여 버전 정보 확인
    named_version=$(named -v 2>/dev/null)

    if [ -n "$named_version" ]; then
        echo "named 버전 정보:"
        echo "----------------------------------------"
        echo "$named_version"
        echo "----------------------------------------"
        result=1
    else
        echo "named 버전 정보를 확인할 수 없습니다."
        result=1
    fi
else
    echo "named 프로세스가 실행되고 있지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "버전정보를 확인해주세요. exit 1"
    echo "DNS 서비스 사용 시 BIND 버전 확인 후 최신 버전으로 업데이트 필요"
    echo "Bind 최신버전 다운로드 사이트 - http://www.isc.org/downloads/"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.15 DNS 보안 버전 패치"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi