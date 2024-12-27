# !/bin/sh

# 기본 결과값
result=0

# httpd.conf 및 apache*.conf 파일 검색
config_files=$(find /etc /usr /var -type f \( -name "httpd.conf" -o -name "apache*.conf" \) 2>/dev/null)

if [ -n "$config_files" ]; then
    for file in $config_files; do
        echo "파일 경로: $file"

        # User 및 Group 설정 확인 (주석 및 LogFormat 제외 후 검사)
        user_setting=$(grep -vEi '^[[:space:]]*#|LogFormat' "$file" | grep -i "User" 2>/dev/null)
        group_setting=$(grep -vEi '^[[:space:]]*#|LogFormat' "$file" | grep -i "Group" 2>/dev/null)

        if [ -n "$user_setting" ] || [ -n "$group_setting" ]; then
            echo "파일 내용에 User/Group 설정이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$user_setting"
            echo "$group_setting"
            echo "----------------------------------------"

            # User 또는 Group이 root인지 확인
            if echo "$user_setting" | grep -iq "User[[:space:]]*root" || \
               echo "$group_setting" | grep -iq "Group[[:space:]]*root"; then
                echo "User 또는 Group이 root로 설정되어 있습니다!"
                result=1

            # User 또는 Group이 변수로 설정된 경우 (${ 확인)
            elif echo "$user_setting" | grep -q "User[[:space:]]*\${" || \
                 echo "$group_setting" | grep -q "Group[[:space:]]*\${"; then
                echo "User 또는 Group이 변수로 설정되어 있습니다."
                echo "실행 중인 프로세스 확인:"
                ps -ef | grep -iE "http|apache" | grep -v "grep"
                result=1
            else
                echo "User 및 Group 설정이 적절하지 않습니다."
            fi
        else
            echo "파일 내용에 User/Group 설정이 없거나 주석 처리되어 있습니다."
        fi
    done
else
    echo "httpd.conf 또는 apache*.conf 파일이 시스템에 존재하지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "User 또는 Group 이 root이거나 변수로 지정되어 있습니다. 프로세스를 실행하는 사용자명을 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.18 웹서비스 웹 프로세스 권한 제한 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi