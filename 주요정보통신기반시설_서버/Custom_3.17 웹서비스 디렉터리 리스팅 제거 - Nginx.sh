# !/bin/sh

# 기본 결과값
result=0

# 가능한 Nginx 설정 파일 경로들
nginx_files="/etc/nginx/nginx.conf /etc/nginx/sites-available/default \
/usr/local/nginx/conf/nginx.conf /usr/local/etc/nginx/nginx.conf \
/opt/nginx/conf/nginx.conf /usr/local/etc/nginx/sites-available/default"

# 설정 파일 존재 여부 확인 및 autoindex 검사
for file in $nginx_files; do
    if [ -f "$file" ]; then
        echo "파일 경로: $file"
        
        # autoindex 설정 확인 (주석 제거 후 검사)
        autoindex_setting=$(grep -vEi '^[[:space:]]*#' "$file" | grep -i "autoindex" 2>/dev/null)
        
        if [ -n "$autoindex_setting" ]; then
            echo "파일 내용에 'autoindex' 설정이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$autoindex_setting"
            echo "----------------------------------------"
            
            # autoindex off 확인
            if echo "$autoindex_setting" | grep -qi "autoindex[[:space:]]*off[[:space:]]*;" || \
               echo "$autoindex_setting" | grep -qi "autoindex[[:space:]]*off[[:space:]]*"; then
                echo "'autoindex off;' 또는 'autoindex off'로 설정되어 있습니다. 조건이 충족되었습니다."
            else
                echo "'autoindex off;' 또는 'autoindex off'로 설정되지 않았습니다!"
                result=1
            fi
        else
            echo "파일 내용에 'autoindex' 설정이 없거나 주석 처리되어 있습니다!"
            result=1
        fi
    else
        echo "파일이 존재하지 않습니다: $file"
    fi
done

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "설정파일에 'autoindex off;' 또는 'autoindex off' 설정을 확인하고 보안 조치를 검토하세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.17 웹서비스 디렉터리 리스팅 제거 (Nginx)"
    echo "확인이 필요한 OS - LINUX, AIX, HP-UX"
    exit 1
fi