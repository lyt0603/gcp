# !/bin/sh

# 기본 결과값
result=1

# /etc/default/passwd 파일 확인
if [ -f "/etc/default/passwd" ]; then
    maxweeks=$(grep -i "MAXWEEKS" /etc/default/passwd 2>/dev/null | grep -viE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$maxweeks" ]; then
        if [ "$maxweeks" -le 12 ]; then
            echo "/etc/default/passwd 파일의 MAXWEEKS 값이 12 이하입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/default/passwd 파일의 MAXWEEKS 값이 12를 초과합니다. 값: $maxweeks"
            result=1
        fi
    else
        echo "/etc/default/passwd 파일에 MAXWEEKS 설정이 없습니다."
        result=1
    fi
fi

# /etc/login.defs 파일 확인
if [ -f "/etc/login.defs" ]; then
    pass_max_days=$(grep -i "PASS_MAX_DAYS" /etc/login.defs 2>/dev/null | grep -viE "^[[:space:]]*#" | awk '{print $2}' | tr -d '[:space:]')
    if [ -n "$pass_max_days" ]; then
        if [ "$pass_max_days" -le 90 ]; then
            echo "/etc/login.defs 파일의 PASS_MAX_DAYS 값이 90 이하입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/login.defs 파일의 PASS_MAX_DAYS 값이 90을 초과합니다. 값: $pass_max_days"
            result=1
        fi
    else
        echo "/etc/login.defs 파일에 PASS_MAX_DAYS 설정이 없습니다."
        result=1
    fi
fi

# /etc/security/user 파일 확인
if [ -f "/etc/security/user" ]; then
    maxage=$(grep -i "maxage" /etc/security/user 2>/dev/null | grep -viE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$maxage" ]; then
        if [ "$maxage" -le 12 ]; then
            echo "/etc/security/user 파일의 maxage 값이 12 이하입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/security/user 파일의 maxage 값이 12를 초과합니다. 값: $maxage"
            result=1
        fi
    else
        echo "/etc/security/user 파일에 maxage 설정이 없습니다."
        result=1
    fi
fi

# /etc/default/security 파일 확인
if [ -f "/etc/default/security" ]; then
    password_maxdays=$(grep -i "PASSWORD_MAXDAYS" /etc/default/security 2>/dev/null | grep -viE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$password_maxdays" ]; then
        if [ "$password_maxdays" -le 90 ]; then
            echo "/etc/default/security 파일의 PASSWORD_MAXDAYS 값이 90 이하입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/default/security 파일의 PASSWORD_MAXDAYS 값이 90을 초과합니다. 값: $password_maxdays"
            result=1
        fi
    else
        echo "/etc/default/security 파일에 PASSWORD_MAXDAYS 설정이 없습니다."
        result=1
    fi
fi

# 모든 조건이 충족되지 않은 경우
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/default/passwd, /etc/login.defs, /etc/security/user, /etc/default/security 설정 파일의 최대 패스워드 사용 기간을 확인하고 수정해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.8 패스워드 최대 사용 기간 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi