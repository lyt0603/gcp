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

        # location 블록 검색 및 disable_symlinks on 확인
        location_blocks=$(awk '/^[[:space:]]*location[[:space:]]+[^\{]*\{/,/^[[:space:]]*\}/' "$file")
        disable_symlinks_check=$(echo "$location_blocks" | grep -vEi '^[[:space:]]*#' | grep -i "disable_symlinks[[:space:]]*on")

        if [ -n "$disable_symlinks_check" ]; then
            echo "파일 내용에 'disable_symlinks on' 설정이 포함된 location 블록이 발견되었습니다:"
            echo "----------------------------------------"
            echo "$disable_symlinks_check"
            echo "----------------------------------------"
            result=0
        elif [ -n "$location_blocks" ]; then
            echo "location 블록은 존재하지만 'disable_symlinks on' 설정이 없습니다."
            echo "----------------------------------------"
            echo "$location_blocks"
            echo "----------------------------------------"
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
    echo "'disable_symlinks on;' 설정을 확인하고 보안 조치를 검토하세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.21 웹서비스 링크 사용금지 (Nginx)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX" 
    exit 1
fi