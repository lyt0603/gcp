# !/bin/sh

# 기본 결과값
result=0
found_file=0

# 가능한 Nginx 설정 파일 경로들
nginx_files="/etc/nginx/nginx.conf /etc/nginx/sites-available/default \
/usr/local/nginx/conf/nginx.conf /usr/local/etc/nginx/nginx.conf \
/opt/nginx/conf/nginx.conf /usr/local/etc/nginx/sites-available/default"

# 설정 파일 검사
for file in $nginx_files; do
    if [ -f "$file" ]; then
        found_file=1
        echo "파일 경로: $file"

        # location 블록 검색
        location_blocks=$(awk '/^[[:space:]]*location[[:space:]]+[^\{]*\{/,/^[[:space:]]*\}/' "$file")

        # 주석 제거된 client_max_body_size 확인
        client_max_body_size=$(echo "$location_blocks" | grep -vEi '^[[:space:]]*#' | grep -i "client_max_body_size")

        if [ -n "$client_max_body_size" ]; then
            echo "파일 내용에 'client_max_body_size' 설정이 발견되었습니다:"
            echo "----------------------------------------"
            echo "$client_max_body_size"
            echo "----------------------------------------"
            result=1
        elif [ -n "$location_blocks" ]; then
            echo "'client_max_body_size' 설정이 없습니다."
            result=1
        else
            echo "파일 내용에 location 블록이 없습니다."
            result=1
        fi
    else
        echo "파일이 존재하지 않습니다: $file"
    fi
done

# 최종 결과 반환
if [ $found_file -eq 0 ]; then
    echo "모든 경로에 파일이 존재하지 않습니다. exit 0"
    exit 0
elif [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "'client_max_body_size' 설정을 확인하고 보안 조치를 검토하세요."
    echo "client_max_body_size는 5m 이하로 설정해야 합니다."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.22 웹서비스 파일 업로드 및 다운로드 제한 (Nginx)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX" 
    exit 1
fi