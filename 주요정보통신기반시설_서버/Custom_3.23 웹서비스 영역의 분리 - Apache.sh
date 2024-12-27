# !/bin/sh

# 기본 결과값
result=0
found_file=0

# DocumentRoot 디렉터리의 기본 값 리스트
valid_paths="/usr/local/apache/htdocs /usr/local/apache2/htdocs /var/www/html"

# httpd.conf 및 apache*.conf 파일 검색
config_files=$(find /etc /usr /var -type f \( -name "httpd.conf" -o -name "apache*.conf" \) 2>/dev/null)

if [ -n "$config_files" ]; then
    for file in $config_files; do
        found_file=1
        echo "파일 경로: $file"

        # DocumentRoot 설정 확인
        document_root=$(grep -vEi '^[[:space:]]*#' "$file" | grep -i "DocumentRoot" 2>/dev/null)

        if [ -n "$document_root" ]; then
            # DocumentRoot가 포함된 경우
            echo "파일 내용에 'DocumentRoot' 설정이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$document_root"
            echo "----------------------------------------"

            # DocumentRoot 값 추출
            doc_root_path=$(echo "$document_root" | grep -oE 'DocumentRoot[[:space:]]*"[^\"]+"' | awk -F'"' '{print $2}')

            # DocumentRoot 값이 유효한지 확인
            if echo "$valid_paths" | grep -q "$doc_root_path"; then
                echo "DocumentRoot 설정이 기본 경로로 설정되어 있습니다: $doc_root_path"
                result=1
            else
                echo "DocumentRoot 설정이 비정상적인 경로로 설정되어 있습니다: $doc_root_path"
                result=0
            fi
        else
            echo "파일 내용에 'DocumentRoot' 설정이 없거나 주석 처리되어 있습니다."
            result=1
        fi
    done
else
    echo "httpd.conf 또는 apache*.conf 파일이 시스템에 존재하지 않습니다."
    exit 0
fi

# 최종 결과 반환
if [ $found_file -eq 0 ]; then
    echo "모든 경로에 파일이 존재하지 않습니다. exit 0"
    exit 0
elif [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "httpd.conf 또는 apache*.conf 파일 내용에 'DocumentRoot' 설정을 확인하고 보안 조치를 검토하세요."
    echo "취약한 경로 - /usr/local/apache/htdocs, /usr/local/apache2/htdocs, /var/www/html 또는 경로가 설정되지 않은 경우"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.23 웹서비스 영역의 분리 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi