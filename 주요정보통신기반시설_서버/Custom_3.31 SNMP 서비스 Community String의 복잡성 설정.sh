# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 SNMP 관련 프로세스 검사
snmp_process=$(ps -ef | grep -i snmp | grep -vE "grep|--color")

if [ -n "$snmp_process" ]; then
    echo "SNMP 프로세스가 실행 중입니다."
    echo "$snmp_process"

    # [2] /etc 아래에서 snmp 관련 설정 파일 검색
    snmp_files=$(find /etc -type f -iname '*snmpd*.conf' 2>/dev/null)

    if [ -z "$snmp_files" ]; then
        echo "/etc 아래에서 SNMP 관련 설정 파일이 발견되지 않았습니다."
    else
        for file in $snmp_files; do
            echo "파일 $file 이 존재합니다. 내용을 확인합니다."

            # "private" 또는 "public" 키워드가 포함된 라인 검사 (대소문자 구분 없음)
            if grep -iqE '^\s*[^#]*\b(private|public)\b' "$file"; then
                echo "파일 $file 에 'private' 또는 'public' 키워드가 포함되어 있습니다:"
                grep -iE '^\s*[^#]*\b(private|public)\b' "$file"
                result=1
            else
                echo "파일 $file 에 'private' 또는 'public' 키워드가 없습니다."
            fi
        done
    fi
else
    echo "SNMP 프로세스가 실행되고 있지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo 'snmpd.conf 또는 snmpd3.conf 설정 파일에 "private" 또는 "public" community string 을 변경해주세요.'
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.31 SNMP 서비스 Community String의 복잡성 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi