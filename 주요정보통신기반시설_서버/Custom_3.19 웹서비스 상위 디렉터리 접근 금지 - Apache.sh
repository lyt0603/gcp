# !/bin/sh

# 기본 결과값
result=0

# httpd.conf 및 apache*.conf 파일 검색
config_files=$(find /etc /usr /var -type f \( -name "httpd.conf" -o -name "apache*.conf" \) 2>/dev/null)

if [ -n "$config_files" ]; then
    for file in $config_files; do
        echo "파일 경로: $file"
        
        # AllowOverride 설정 확인 (주석 제거 후 검사)
        allowoverride_settings=$(grep -iE "AllowOverride" "$file" | grep -vE '^[[:space:]]*#')
        
        if [ -n "$allowoverride_settings" ]; then
            echo "파일 내용에 'AllowOverride' 설정이 포함되어 있습니다:"
            echo "----------------------------------------"
            echo "$allowoverride_settings"
            echo "----------------------------------------"

            # AllowOverride None 확인
            if echo "$allowoverride_settings" | grep -iE "AllowOverride[[:space:]]*None" > /dev/null; then
                echo "AllowOverride None 설정이 발견되었습니다!"
                result=1
            elif echo "$allowoverride_settings" | grep -iE "AllowOverride[[:space:]]*(AuthConfig|All)" > /dev/null; then
                echo "AllowOverride AuthConfig 또는 AllowOverride All 설정이 발견되었습니다."
                result=0
            else
                echo "AllowOverride 설정이 적절하지 않습니다."
                result=1
            fi
        else
            echo "파일 내용에 'AllowOverride' 설정이 없거나 주석 처리되어 있습니다."
            result=1
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
    echo "'AllowOverride ~' 설정을 확인하고 보안 조치를 검토하세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.19 웹서비스 상위 디렉터리 접근 금지 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi