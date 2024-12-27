# !/bin/sh

# 기본 결과값
result=0

# httpd.conf 및 apache*.conf 파일 검색
config_files=$(find /etc /usr /var -type f \( -name "httpd.conf" -o -name "apache*.conf" \) 2>/dev/null)

if [ -n "$config_files" ]; then
    for file in $config_files; do
        echo "파일 경로: $file"

        # LimitRequestBody 설정 확인 (주석 제거 후 검사)
        limit_request_body=$(grep -vEi '^[[:space:]]*#' "$file" | grep -i "LimitRequestBody" 2>/dev/null)

        if [ -n "$limit_request_body" ]; then
            echo "파일 내용에 'LimitRequestBody' 설정이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$limit_request_body"
            echo "----------------------------------------"

            # LimitRequestBody 값 확인
            if echo "$limit_request_body" | grep -qiE "LimitRequestBody[[:space:]]*[0-9]+"; then
                limit_value=$(echo "$limit_request_body" | grep -oE "[0-9]+")
                if [ "$limit_value" -le 5000000 ]; then
                    echo "LimitRequestBody 설정이 5000000 이하로 설정되어 있습니다. 조건이 충족되었습니다."
                    result=0
                else
                    echo "LimitRequestBody 설정이 5000000을 초과합니다!"
                    result=1
                fi
            else
                echo "LimitRequestBody 설정 값이 올바르지 않습니다."
                result=1
            fi
        else
            echo "파일 내용에 'LimitRequestBody' 설정이 없거나 주석 처리되어 있습니다."
        fi
    done
else
    echo "httpd.conf 또는 apache*.conf 파일이 시스템에 존재하지 않습니다. exit 0"
    exit 0
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "'LimitRequestBody' 설정을 확인하고 보안 조치를 검토하세요."
    echo "LimitRequestBody는 5000000 이하로 설정해야 합니다."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.22 웹서비스 파일 업로드 및 다운로드 제한 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX" 
    exit 1
fi