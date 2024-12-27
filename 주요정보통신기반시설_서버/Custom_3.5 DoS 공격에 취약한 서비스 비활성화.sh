# !/bin/sh

# 기본 결과값
result=0

# [조건 1] /etc/inetd.conf 파일에 echo, daytime, discard, chargen 검사
if [ -f /etc/inetd.conf ]; then
    r_services=$(grep -E "^[^#]*\b(echo|daytime|discard|chargen)\b" /etc/inetd.conf 2>/dev/null)
    if [ -n "$r_services" ]; then
        echo "/etc/inetd.conf 파일에 echo, daytime, discard, chargen 서비스가 존재합니다."
        echo "해당 내용:"
        echo "$r_services"
        result=1
    else
        echo "/etc/inetd.conf 파일에 echo, daytime, discard, chargen 서비스가 존재하지 않거나 활성화 되어있지 않습니다. 있습니다."
    fi
else
    echo "/etc/inetd.conf 파일이 존재하지 않습니다."
fi

# [조건 2] /etc/xinetd.d/에서 echo, discard, daytime, chargen 검사
xinetd_files="/etc/xinetd.d/echo /etc/xinetd.d/discard /etc/xinetd.d/daytime /etc/xinetd.d/chargen"

for file in $xinetd_files; do
    if [ -f "$file" ]; then
        # disable 상태 확인
        disable_status=$(grep -E "disable[[:space:]]*=[[:space:]]*(yes|no)" "$file" 2>/dev/null)

        if echo "$disable_status" | grep -qi "disable[[:space:]]*=[[:space:]]*no"; then
            echo "$file 파일에 서비스가 활성화 되어 있습니다.(disable = no)"
            cat "$file"
            result=1
        elif echo "$disable_status" | grep -qi "disable[[:space:]]*=[[:space:]]*yes"; then
            echo "$file 파일에 서비스가 활성화 되어있지 않습니다.(disable = yes)"
        else
            echo "$file 파일에 disable 설정이 존재하지 않습니다."
            result=1
        fi
    fi
done

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/inetd.conf /etc/xinetd.d/ 파일에서 echo, daytime, discard, chargen 활성화 여부를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.5 DoS 공격에 취약한 서비스 비활성화"
    echo "확인이 필요한 OS - LINUX, AIX, HP-UX"
    exit 1
fi