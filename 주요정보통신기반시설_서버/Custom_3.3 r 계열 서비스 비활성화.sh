# !/bin/sh

# 기본 결과값
result=0

if [ -f /etc/inetd.conf ]; then
    r_commands=$(grep -E "^[^#]*(login|shell|exec).*r(sh|login|exec|shd|logind|execd|users|cp|who|uptime|sync|date)" /etc/inetd.conf 2>/dev/null)
    if [ -n "$r_commands" ]; then
        echo "/etc/inetd.conf 파일에 login, shell, exec 중 r command가 활성화 되어 있습니다."
        echo "$r_commands"
        result=1
    else
        echo "/etc/inetd.conf 파일에 login, shell, exec 중 r command가 존재하지 않거나 활성화 되어있지 않습니다."
    fi
fi

# inetadm 명령어로 shell, rlogin, rexec 관련 데몬 검사
if command -v inetadm >/dev/null 2>&1; then
    inetadm_output=$(inetadm | grep -E "shell|rlogin|rexec" 2>/dev/null)
    if [ -n "$inetadm_output" ]; then
        echo "inetadm 에서 r command 관련 데몬이 활성화 되어 있습니다."
        echo "$inetadm_output"
        result=1
    else
        echo "inetadm 에서 r command 관련 데몬이 존재하지 않거나 활성화 되어 있지 않습니다."
    fi
fi

# /etc/xinetd.d/ 에서 rsh, rlogin, rexec 관련 파일 검사
xinetd_files=$(ls -alL /etc/xinetd.d/* 2>/dev/null | grep -E "rsh|rlogin|rexec" | grep -vE "grep|klogin|kshell|kexec")
if [ -n "$xinetd_files" ]; then

    # 각 파일 확인
    for file in $(echo "$xinetd_files" | awk '{print $NF}'); do
        if [ -f "$file" ]; then
            disable_status=$(grep -E "disable[[:space:]]*=[[:space:]]*(yes|no)" "$file" 2>/dev/null)
            if echo "$disable_status" | grep -qi "disable[[:space:]]*=[[:space:]]*no"; then
                echo "$file 파일에 r 서비스가 활성화 되어 있습니다.(disable = no)"
                cat "$file"
                result=1
            elif echo "$disable_status" | grep -qi "disable[[:space:]]*=[[:space:]]*yes"; then
                echo "$file 파일에 r 서비스가 활성화 되어있지 않습니다.(disable = yes)"
            else
                echo "$file 파일에 disable 설정이 존재하지 않습니다."
                cat "$file"
                result=1
            fi
        fi
    done
else
    echo "/etc/xinetd.d/ 에 rsh, rlogin, rexec 관련 파일이 존재하지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/inetd.conf 에 활성화 된 r 서비스를 확인해주세요."
    echo "/etc/xinetd.d/rsh /etc/xinetd.d/rlogin /etc/xinetd.d/rexec 에 disable 설정을 확인해주세요."    
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.3 r 계열 서비스 비활성화"
    echo "확인이 필요한 OS - LINUX, AIX, HP-UX"
    exit 1
fi