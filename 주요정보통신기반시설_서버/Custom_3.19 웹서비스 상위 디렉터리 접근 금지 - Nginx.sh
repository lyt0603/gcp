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

        if echo "$location_blocks" | grep -q "location"; then
            echo "파일 내용에 'location' 블록이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$location_blocks"
            echo "----------------------------------------"
            result=1
        else
            echo "파일 내용에 'location' 키워드가 없습니다."
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
elif [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "파일에서 'location' 라인에 'root /path/to/your/webroot;' 'try_files $uri $uri/ =404;' 를 포함하고 있는지 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.19 웹서비스 디렉터리 리스팅 제거 (Nginx)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi