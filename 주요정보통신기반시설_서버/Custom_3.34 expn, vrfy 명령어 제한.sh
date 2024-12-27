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
        # PrivacyOptions 설정 확인
        privacy_options=$(grep -Ei "PrivacyOptions=" "$sendmail_cf" 2>/dev/null)

        if [ -n "$privacy_options" ]; then
            # 주석을 제거하고 PrivacyOptions 값을 소문자로 정규화하여 확인
            uncommented_options=$(echo "$privacy_options" | grep -vE '^[[:space:]]*#' | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

            # noexpn, novrfy, goaway 옵션 확인 (대소문자 및 공백 무시)
            if echo "$uncommented_options" | grep -qiE "privacyoptions=.*(noexpn|novrfy|goaway)"; then
                echo "PrivacyOptions 설정에 noexpn, novrfy, goaway 중 하나 이상의 옵션이 포함되어 있습니다."
                echo "----------------------------------------"
                echo "$privacy_options"
                echo "----------------------------------------"
                result=1
            else
                echo "PrivacyOptions 설정에 noexpn, novrfy, goaway 옵션이 포함되지 않았거나 모두 주석 처리되어 있습니다."
            fi
        else
            echo "PrivacyOptions 설정이 sendmail.cf 파일에 존재하지 않습니다."
        fi
    else
        echo "$sendmail_cf 파일이 존재하지 않습니다."
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
    echo "/etc/mail/sendmail.cf 파일에서 PrivacyOptions 설정에 noexpn 또는 novrfy 또는 goaway 를 제거해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.34 expn, vrfy 명령어 제한"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi