# !/bin/sh

# 결과값 초기화
result=1  # 기본값을 조건 미충족(1)으로 설정

# 주석을 포함하지 않은 유효한 값 확인 함수
check_valid_config() {
    file=$1
    shift
    for pattern in "$@"; do
        if ! grep -Eiq "^[[:space:]]*[^#]*$pattern" "$file" 2>/dev/null; then
            return 1
        fi
    done
    return 0
}

# RHEL7 조건
if check_valid_config "/etc/security/pwquality.conf" "minlen=[8-9][0-9]*" "lcredit=-[1-9][0-9]*" "ucredit=-[1-9][0-9]*" "dcredit=-[1-9][0-9]*" "ocredit=-[1-9][0-9]*" "difok=N"; then
    echo "/etc/security/pwquality.conf: 조건이 확인되었습니다."
    result=0
else
    echo "/etc/security/pwquality.conf: 조건이 충족되지 않았습니다."
fi

# RHEL5 조건
if check_valid_config "/etc/pam.d/system-auth" "minlen=[8-9][0-9]*" "lcredit=-[1-9][0-9]*" "ucredit=-[1-9][0-9]*" "dcredit=-[1-9][0-9]*" "ocredit=-[1-9][0-9]*" "difok=N"; then
    echo "/etc/pam.d/system-auth: 조건이 확인되었습니다."
    result=0
else
    echo "/etc/pam.d/system-auth: 조건이 충족되지 않았습니다."
fi

# AIX 조건
if check_valid_config "/etc/security/user" "minlen=[8-9][0-9]*" "minother=[2-9][0-9]*" "minalpha=[2-9][0-9]*" "mindiff=[4-9][0-9]*" "maxrepeats=[2-9][0-9]*"; then
    echo "/etc/security/user: 조건이 확인되었습니다."
    result=0
else
    echo "/etc/security/user: 조건이 충족되지 않았습니다."
fi

# Solaris 조건
if check_valid_config "/etc/default/passwd" "passlength=[8-9][0-9]*" "MINDIFF=[4-9][0-9]*" "MINALPHA=[1-9][0-9]*" "MINNONALPHA=[1-9][0-9]*" "MINUPPER=[1-9][0-9]*" "MINLOWER=[1-9][0-9]*" "MAXREPEATS=0" "MINSPECIAL=[1-9][0-9]*" "MINDIGIT=[1-9][0-9]*" "NAMECHECK=YES"; then
    echo "/etc/default/passwd: 조건이 확인되었습니다."
    result=0
else
    echo "/etc/default/passwd: 조건이 충족되지 않았습니다."
fi

# HP-UX 조건
if check_valid_config "/etc/default/security" "MIN_PASSWORD_LENGTH=[8-9][0-9]*" "PASSWORD_MIN_UPPER_CASE_CHARS=[1-9][0-9]*" "PASSWORD_MIN_LOWER_CASE_CHARS=[1-9][0-9]*" "PASSWORD_MIN_DIGIT_CHARS=[1-9][0-9]*" "PASSWORD_MIN_SPECIAL_CHARS=[1-9][0-9]*"; then
    echo "/etc/default/security: 조건이 확인되었습니다."
    result=0
else
    echo "/etc/default/security: 조건이 충족되지 않았습니다."
fi

# 최종 결과 출력
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.2 패스워드 복잡성 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi