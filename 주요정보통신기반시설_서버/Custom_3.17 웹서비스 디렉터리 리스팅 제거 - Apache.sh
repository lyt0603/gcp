# !/bin/sh

# 기본 결과값
result=0

# [1] httpd.conf 및 apache*.conf 파일 검색
config_files=$(find /etc /usr /var -type f \( -name "httpd.conf" -o -name "apache*.conf" \) 2>/dev/null)

if [ -n "$config_files" ]; then
    for file in $config_files; do
        echo "파일 경로: $file"
        # Options Indexes 설정 확인 (주석 제거 후 검사)
        options_indexes=$(grep -vEi '^[[:space:]]*#' "$file" | grep "Options.*Indexes" 2>/dev/null)

        if [ -n "$options_indexes" ]; then
            echo "파일 내용에 'Options Indexes' 설정이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$options_indexes"
            echo "----------------------------------------"
            result=1
        else
            echo "파일 내용에 'Options Indexes' 설정이 없거나 주석 처리되어 있습니다."
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
    echo "'Options Indexes ~' 설정을 확인하고 보안 조치를 검토하세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.17 웹서비스 디렉터리 리스팅 제거 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi