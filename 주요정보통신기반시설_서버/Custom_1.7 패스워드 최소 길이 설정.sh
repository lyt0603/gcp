# !/bin/sh

# 기본 결과값
result=1

# /etc/default/passwd 파일 확인
if grep -qviE "^[[:space:]]*#" /etc/default/passwd 2>/dev/null; then
    passwd_min_length=$(grep -i "PASSLENGTH" /etc/default/passwd 2>/dev/null | grep -vE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$passwd_min_length" ] && [ "$passwd_min_length" -ge 8 ]; then
        echo "/etc/default/passwd 파일의 PASSLENGTH 값이 8 이상입니다. 조건이 충족되었습니다."
        exit 0
    fi
fi

# /etc/login.defs 파일 확인
if grep -qviE "^[[:space:]]*#" /etc/login.defs 2>/dev/null; then
    login_defs_min_length=$(grep -i "PASS_MIN_LEN" /etc/login.defs 2>/dev/null | grep -vE "^[[:space:]]*#" | awk '{print $2}' | tr -d '[:space:]')
    if [ -n "$login_defs_min_length" ] && [ "$login_defs_min_length" -ge 8 ]; then
        echo "/etc/login.defs 파일의 PASS_MIN_LEN 값이 8 이상입니다. 조건이 충족되었습니다."
        exit 0
    fi
fi

# /etc/security/user 파일 확인
if grep -qviE "^[[:space:]]*#" /etc/security/user 2>/dev/null; then
    security_user_minlen=$(grep -i "minlen" /etc/security/user 2>/dev/null | grep -vE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$security_user_minlen" ] && [ "$security_user_minlen" -ge 8 ]; then
        echo "/etc/security/user 파일의 minlen 값이 8 이상입니다. 조건이 충족되었습니다."
        exit 0
    fi
fi

# /etc/default/security 파일 확인
if grep -qviE "^[[:space:]]*#" /etc/default/security 2>/dev/null; then
    security_min_password_length=$(grep -i "MIN_PASSWORD_LENGTH" /etc/default/security 2>/dev/null | grep -vE "^[[:space:]]*#" | awk -F'=' '{print $2}' | tr -d '[:space:]')
    if [ -n "$security_min_password_length" ] && [ "$security_min_password_length" -ge 8 ]; then
        echo "/etc/default/security 파일의 MIN_PASSWORD_LENGTH 값이 8 이상입니다. 조건이 충족되었습니다."
        exit 0
    fi
fi

# 모든 조건이 충족되지 않은 경우
echo "조건이 확인되지 않았습니다. exit 1"
echo "/etc/default/passwd /etc/login.defs /etc/security/user /etc/default/security 설정 파일의 패스워드 최소 길이를 확인하고 수정해주세요(8자리 이상)."
echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.7 패스워드 최소 길이 설정"
echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
exit 1