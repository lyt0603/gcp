# !/bin/sh

# 기본 결과값
result=0

# [조건 1] /etc/inetd.conf 에서 tftp, talk, ntalk 관련 서비스 검사
inetd_services="tftp|talk|ntalk"

if [ -f "/etc/inetd.conf" ]; then
    inetd_output=$(grep -E "^[^#]*\b($inetd_services)\b" /etc/inetd.conf 2>/dev/null)
    if [ -n "$inetd_output" ]; then
        echo "/etc/inetd.conf 에서 tftp, talk, ntalk 관련 서비스가 활성화 되어 있습니다:"
        echo "$inetd_output"
        result=1
    else
        echo "/etc/inetd.conf 에서 tftp, talk, ntalk 관련 서비스가 존재하지 않거나 활성화 되어 있지 않습니다."
    fi
else
    echo "/etc/inetd.conf 파일이 존재하지 않습니다."
fi

# [조건 2] /etc/xinetd.d/ 내 tftp, talk, ntalk 관련 서비스 확인
xinetd_dir="/etc/xinetd.d"
if [ -d "$xinetd_dir" ]; then
    for service in tftp talk ntalk; do
        service_file="$xinetd_dir/$service"
        if [ -f "$service_file" ]; then
            disable_status=$(grep -E "disable[[:space:]]*=[[:space:]]*(yes|no)" "$service_file" | tr -d '[:space:]')
            if echo "$disable_status" | grep -qi "disable=no"; then
                echo "$service_file 파일에 $service 서비스가 활성화 되어 있습니다.(disable = no)"
                cat "$service_file"
                result=1
            elif echo "$disable_status" | grep -qi "disable=yes"; then
                echo "$service_file 파일에 $service 서비스가 비활성화 되어 있습니다.(disable = yes)"
            else
                echo "$service_file 파일에 disable 설정이 존재하지 않습니다."
                cat "$service_file"
                result=1
            fi
        fi
    done
else
    echo "/etc/xinetd.d 디렉터리가 존재하지 않습니다."
fi

# [조건 3] inetadm 명령어를 통해 tftp, talk 관련 서비스 검사 (Solaris 환경)
if command -v inetadm >/dev/null 2>&1; then
    inetadm_output=$(inetadm | egrep "tftp|talk" 2>/dev/null)

    if [ -n "$inetadm_output" ]; then
        echo "inetadm 에서 tftp, talk 관련 서비스가 활성화되어 있습니다:"
        echo "$inetadm_output"
        result=1
    else
        echo "inetadm 에서 tftp, talk 관련 서비스가 활성화 되어 있지 않습니다."
    fi
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "tftp, talk, ntalk 서비스를 비활성화 해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.11 tftp, talk 서비스 비활성화"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi