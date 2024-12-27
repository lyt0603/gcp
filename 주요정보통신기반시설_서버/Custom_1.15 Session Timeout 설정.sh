# !/bin/sh

# 기본 결과값
result=1

# /etc/profile 또는 /etc/.profile에서 TMOUT 확인
if [ -f "/etc/profile" ] || [ -f "/etc/.profile" ]; then
    profile_tmout=$(grep -iE "^\s*TMOUT\s*=\s*[0-9]+" /etc/profile /etc/.profile 2>/dev/null | grep -vE "^[[:space:]]*#")
    profile_export=$(grep -iE "^\s*export\s+TMOUT" /etc/profile /etc/.profile 2>/dev/null | grep -vE "^[[:space:]]*#")

    if [ -n "$profile_tmout" ] && [ -n "$profile_export" ]; then
        tmout_value=$(echo "$profile_tmout" | awk -F'=' '{print $2}' | tr -d '[:space:]')
        if [ "$tmout_value" -le 600 ]; then
            echo "/etc/profile 또는 /etc/.profile에 TMOUT 설정이 600 이하로 설정되어 있습니다."
            echo "TMOUT 설정: $profile_tmout"
            result=0
        else
            echo "/etc/profile 또는 /etc/.profile에 TMOUT 설정이 600을 초과합니다. 설정된 값: $tmout_value"
        fi
    else
        echo "/etc/profile 또는 /etc/.profile에 TMOUT 설정이 주석 처리되었거나 존재하지 않습니다."
    fi
else
    echo "/etc/profile 또는 /etc/.profile 파일이 존재하지 않습니다."
fi

# /etc/csh.login 또는 /etc/csh.cshrc에서 autologout 확인
if [ -f "/etc/csh.login" ] || [ -f "/etc/csh.cshrc" ]; then
    csh_autologout=$(grep -iE "^\s*set\s+autologout\s*=\s*[0-9]+" /etc/csh.login /etc/csh.cshrc 2>/dev/null | grep -vE "^[[:space:]]*#")

    if [ -n "$csh_autologout" ]; then
        autologout_value=$(echo "$csh_autologout" | awk -F'=' '{print $2}' | tr -d '[:space:]')
        if [ "$autologout_value" -le 10 ]; then
            echo "/etc/csh.login 또는 /etc/csh.cshrc에 autologout 설정이 10 이하로 설정되어 있습니다."
            echo "autologout 설정: $csh_autologout"
            result=0
        else
            echo "/etc/csh.login 또는 /etc/csh.cshrc에 autologout 설정이 10을 초과합니다. 설정된 값: $autologout_value"
        fi
    else
        echo "/etc/csh.login 또는 /etc/csh.cshrc에 autologout 설정이 주석 처리되었거나 존재하지 않습니다."
    fi
else
    echo "/etc/csh.login 또는 /etc/csh.cshrc 파일이 존재하지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 충족되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/profile 또는 /etc/.profile에 timeout 을 설정해주세요."
    echo "/etc/csh.login 또는 /etc/csh.cshrc에 autologout 을 설정해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.15 Session Timeout 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi