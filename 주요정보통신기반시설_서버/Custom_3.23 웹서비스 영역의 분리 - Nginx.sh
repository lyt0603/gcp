# !/bin/sh

# 기본 결과값
result=0
found_file=0

# 유효하지 않은 기본 root 경로
invalid_roots="/usr/share/nginx/html /var/www/html"

# 가능한 Nginx 설정 파일 경로들
nginx_files="/etc/nginx/nginx.conf /etc/nginx/sites-available/default \
/usr/local/nginx/conf/nginx.conf /usr/local/etc/nginx/nginx.conf \
/opt/nginx/conf/nginx.conf /usr/local/etc/nginx/sites-available/default"

# 설정 파일 검사
for file in $nginx_files; do
    if [ -f "$file" ]; then
        found_file=1
        echo "파일 경로: $file"

        # root 설정 검색 (주석 제거 후 확인)
        root_setting=$(grep -vEi '^[[:space:]]*#' "$file" | grep -i 'root[[:space:]]*/')

        if [ -n "$root_setting" ]; then
            echo "파일에서 'root' 설정이 발견되었습니다:"
            echo "----------------------------------------"
            echo "$root_setting"
            echo "----------------------------------------"

            # 설정된 root 값을 확인
            root_value=$(echo "$root_setting" | grep -oE 'root[[:space:]]+/[^;]+' | awk '{print $2}')
            if echo "$invalid_roots" | grep -qw "$root_value"; then
                echo "유효하지 않은 root 경로가 설정되었습니다: $root_value"
                result=1
            else
                echo "root 경로가 적절하게 설정되었습니다: $root_value"
            fi
        else
            echo "root 설정이 주석 처리되었거나 설정되지 않았습니다."
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
    echo "nginx.conf 또는 default 파일에서 'root' 설정을 확인하고 보안 조치를 검토하세요"
    echo "root 경로는 '/usr/share/nginx/html' 또는 '/var/www/html' 외의 경로로 설정해야 합니다."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.23 웹서비스 영역의 분리 (Nginx)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi