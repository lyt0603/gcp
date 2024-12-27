# !/bin/sh

# 기본 결과값
result=1

# /etc/default/passwd 파일 확인
if [ -f "/etc/default/passwd" ]; then
    minweeks=$(grep -i "MINWEEKS" /etc/default/passwd 2>/dev/null | grep -viE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$minweeks" ]; then
        if [ "$minweeks" -ge 1 ]; then
            echo "/etc/default/passwd 파일의 MINWEEKS 값이 1 이상입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/default/passwd 파일의 MINWEEKS 값이 1 미만입니다. 값: $minweeks"
            result=1
        fi
    else
        echo "/etc/default/passwd 파일에 MINWEEKS 설정이 없습니다."
        result=1
    fi
fi

# /etc/login.defs 파일 확인
if [ -f "/etc/login.defs" ]; then
    pass_min_days=$(grep -i "PASS_MIN_DAYS" /etc/login.defs 2>/dev/null | grep -viE "^[[:space:]]*#" | awk '{print $2}' | tr -d '[:space:]')
    if [ -n "$pass_min_days" ]; then
        if [ "$pass_min_days" -ge 1 ]; then
            echo "/etc/login.defs 파일의 PASS_MIN_DAYS 값이 1 이상입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/login.defs 파일의 PASS_MIN_DAYS 값이 1 미만입니다. 값: $pass_min_days"
            result=1
        fi
    else
        echo "/etc/login.defs 파일에 PASS_MIN_DAYS 설정이 없습니다."
        result=1
    fi
fi

# /etc/security/user 파일 확인
if [ -f "/etc/security/user" ]; then
    minage=$(grep -i "minage" /etc/security/user 2>/dev/null | grep -viE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$minage" ]; then
        if [ "$minage" -ge 1 ]; then
            echo "/etc/security/user 파일의 minage 값이 1 이상입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/security/user 파일의 minage 값이 1 미만입니다. 값: $minage"
            result=1
        fi
    else
        echo "/etc/security/user 파일에 minage 설정이 없습니다."
        result=1
    fi
fi

# /etc/default/security 파일 확인
if [ -f "/etc/default/security" ]; then
    password_mindays=$(grep -i "PASSWORD_MINDAYS" /etc/default/security 2>/dev/null | grep -viE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$password_mindays" ]; then
        if [ "$password_mindays" -ge 1 ]; then
            echo "/etc/default/security 파일의 PASSWORD_MINDAYS 값이 1 이상입니다. 조건이 충족되었습니다."
            exit 0
        else
            echo "/etc/default/security 파일의 PASSWORD_MINDAYS 값이 1 미만입니다. 값: $password_mindays"
            result=1
        fi
    else
        echo "/etc/default/security 파일에 PASSWORD_MINDAYS 설정이 없습니다."
        result=1
    fi
fi

# 모든 조건이 충족되지 않은 경우
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/default/passwd, /etc/login.defs, /etc/security/user, /etc/default/security 설정 파일의 최소 패스워드 사용 기간을 확인하고 수정해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.9 패스워드 최소 사용 기간 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi