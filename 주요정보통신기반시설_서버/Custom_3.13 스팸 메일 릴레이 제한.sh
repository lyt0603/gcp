# !/bin/sh

# 기본 결과값
result=0

# [1] ps -ef 명령어를 통해 sendmail 프로세스 검사
sendmail_process=$(ps -ef | grep "sendmail" | grep -vE "grep|--color|egrep")

if [ -n "$sendmail_process" ]; then
    echo "sendmail 프로세스가 실행 중입니다."
    echo "$sendmail_process"

    # /etc/mail/sendmail.cf 파일 검사
    sendmail_cf="/etc/mail/sendmail.cf"
    if [ -f "$sendmail_cf" ]; then
        # 주석이 아닌 R$* Relaying denied 설정 확인
        relaying_denied=$(grep -vE '^[[:space:]]*#' "$sendmail_cf" | grep -E '^R\$[*][[:space:]]+.*Relaying denied' 2>/dev/null)
        if [ -n "$relaying_denied" ]; then
            echo "Relaying denied 설정이 확인되었습니다."
            echo "----------------------------------------"
            echo "$relaying_denied"
            echo "----------------------------------------"
            result=1
        else
            echo "Relaying denied 설정이 존재하지 않습니다."
        fi
    else
        echo "$sendmail_cf 파일이 존재하지 않습니다."
        result=1
    fi
else
    echo "sendmail 프로세스가 실행되고 있지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/mail/sendmail.cf 파일에서 Relaying denied 설정을 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.13 스팸 메일 릴레이 제한"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi