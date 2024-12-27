# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 SNMP 관련 프로세스 검사
snmp_process=$(ps -ef | grep snmp | grep -vE "grep|--color")

if [ -n "$snmp_process" ]; then
    echo "SNMP 프로세스가 실행 중입니다."
    echo "$snmp_process"
    result=1
else
    echo "SNMP 프로세스가 실행되고 있지 않습니다."
fi

# [2] svcs 명령어를 통해 SNMP 관련 서비스 검사 (Solaris 및 Linux 환경)
if command -v svcs >/dev/null 2>&1; then
    svcs_output=$(svcs -a | grep snmp 2>/dev/null)

    if [ -n "$svcs_output" ]; then
        echo "svcs 에서 SNMP 서비스가 활성화되어 있습니다:"
        echo "$svcs_output"
        result=1
    else
        echo "svcs 에서 SNMP 관련 서비스가 활성화되어 있지 않습니다."
    fi
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "SNMP 서비스를 사용하지 않는 경우 중지해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.30 SNMP 서비스 구동 점검"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi