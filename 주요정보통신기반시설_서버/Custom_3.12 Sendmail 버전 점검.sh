# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 sendmail 프로세스 검사
sendmail_process=$(ps -ef | grep "sendmail" | grep -vE "grep|--color|egrep")

if [ -n "$sendmail_process" ]; then
    echo "sendmail 프로세스가 실행 중입니다."
    echo "$sendmail_process"
    
    # sendmail -d0.1 < /dev/null 명령 실행하여 버전 정보 확인
    sendmail_version=$(sendmail -d0.1 < /dev/null 2>/dev/null)
    
    if [ -n "$sendmail_version" ]; then
        echo "sendmail 버전 정보:"
        echo "----------------------------------------"
        echo "$sendmail_version"
        echo "----------------------------------------"
    else
        echo "sendmail 버전 정보를 확인할 수 없습니다."
    fi
    
    result=1
else
    echo "sendmail 프로세스가 실행되고 있지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo '"http://www.sendmail.org/" 에서 취약한 버전의 버전정보를 확인해주세요.'
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.12 Sendmail 버전 점검"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi