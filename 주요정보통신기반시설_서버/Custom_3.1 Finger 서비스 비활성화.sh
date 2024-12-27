# !/bin/sh

# 기본 결과값
result=0

# 1. /etc/inetd.conf 에서 finger 서비스 검사
inetd_finger_output=$(grep -E "^[^#]*finger" /etc/inetd.conf 2>/dev/null || echo "")
if [ -n "$inetd_finger_output" ]; then
    echo "/etc/inetd.conf 파일에 finger 서비스가 활성화 되어 있습니다."
    echo "$inetd_finger_output"
    result=1

else
    echo "/etc/inetd.conf 파일에 finger 서비스가 활성화 되어 있지 않습니다."

fi

# 2. /etc/xinetd.d/ 에서 finger 서비스 파일 검사
xinetd_finger_files=$(ls -1 /etc/xinetd.d/* 2>/dev/null | grep "finger" || echo "")

if [ -n "$xinetd_finger_files" ]; then
    # finger 파일이 존재하는 경우
    for file in $xinetd_finger_files; do
        disable_status=$(grep -E "disable[[:space:]]*=[[:space:]]*(yes|no)" "$file" 2>/dev/null)

        if echo "$disable_status" | grep -qi "disable[[:space:]]*=[[:space:]]*no"; then
            # disable = no 인 경우
            echo "$file 파일에 finger 서비스가 활성화(disable = no) 되어 있습니다."
            cat "$file"
            result=1
        elif echo "$disable_status" | grep -qi "disable[[:space:]]*=[[:space:]]*yes"; then
            # disable = yes 인 경우
            echo "$file 파일에서 finger 서비스가 활성화 되어 있지 않습니다.(disable = yes)"
        else
            # disable 항목이 존재하지 않는 경우
            echo "$file 파일에 disable 설정이 존재하지 않습니다."
            cat "$file"
            result=1
        fi
    done
else
    echo "/etc/xinetd.d/에서 finger 서비스 파일이 존재하지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "finger 서비스의 활성화 여부를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.1 finger 서비스 비활성화"
    echo "확인이 필요한 OS - LINUX, AIX, HP-UX"
    exit 1
fi