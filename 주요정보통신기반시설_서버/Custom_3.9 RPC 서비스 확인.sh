# !/bin/sh

# 기본 결과값
result=0

# [조건 1] /etc/inetd.conf 에서 rpc 관련 서비스 검사
inetd_services="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rexd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd"

if [ -f "/etc/inetd.conf" ]; then
    inetd_output=$(grep -E "^[^#]*\b($inetd_services)\b" /etc/inetd.conf 2>/dev/null)
    if [ -n "$inetd_output" ]; then
        echo "/etc/inetd.conf 에서 rpc 관련 서비스가 활성화 되어 있습니다:"
        echo "$inetd_output"
        result=1
    else
        echo "/etc/inetd.conf 에서 rpc 서비스가 존재하지 않거나 활성화 되어 있지 않습니다."
    fi
else
    echo "/etc/inetd.conf 파일이 존재하지 않습니다."
fi

# [조건 2] /etc/xinetd.d/ 내 rpc 관련 서비스 확인
xinetd_dir="/etc/xinetd.d"
if [ -d "$xinetd_dir" ]; then
    xinetd_files=$(grep -El "$inetd_services" "$xinetd_dir"/* 2>/dev/null)
    if [ -n "$xinetd_files" ]; then
        for file in $xinetd_files; do
            disable_status=$(grep -E "disable[[:space:]]*=[[:space:]]*(yes|no)" "$file" | tr -d '[:space:]')
            if echo "$disable_status" | grep -qi "disable=no"; then
                echo "$file 파일에 rpc 서비스가 활성화 되어 있습니다.(disable = no)"
                cat "$file"
                result=1
            elif echo "$disable_status" | grep -qi "disable=yes"; then
                echo "$file 파일에 rpc 서비스가 활성화 되어있지 않습니다.(disable = yes)"
            else
                echo "$file 파일에 disable 설정이 존재하지 않습니다."
                result=1
            fi
        done
    else
        echo "/etc/xinetd.d/ 내 rpc 관련 파일이 존재하지 않습니다."
    fi
else
    echo "/etc/xinetd.d 디렉터리가 존재하지 않습니다."
fi

# [조건 3] inetadm 명령어를 통해 rpc 관련 서비스 검사 (Solaris 환경)
if command -v inetadm >/dev/null 2>&1; then
    inetadm_output=$(inetadm | grep rpc | grep enabled | egrep "ttdbserver|rex|rstart|rusers|spray|wall|rquota" 2>/dev/null)
    if [ -n "$inetadm_output" ]; then
        echo "inetadm 에서 rpc 관련 서비스가 활성화되어 있습니다:"
        echo "$inetadm_output"
        result=1
    else
        echo "inetadm 에서 rpc 관련 서비스가 활성화 되어 있지 않습니다."
    fi
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "rpc 관련 서비스를 비활성화 해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.9 RPC 서비스 확인"   
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi