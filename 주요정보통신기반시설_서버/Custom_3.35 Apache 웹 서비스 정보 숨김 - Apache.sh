# !/bin/sh

# 기본 결과값
result=1  # 기본값을 조건 불충족으로 설정

# 검사할 설정 파일 검색
config_files=$(find /etc /usr /var -type f \( -name "httpd.conf" -o -name "apache*.conf" \) 2>/dev/null)

if [ -z "$config_files" ]; then
    echo "HTTPD 또는 Apache 설정 파일이 존재하지 않습니다. exit 0"
    exit 0
fi

# 설정 파일 내용 검사
for config_file in $config_files; do
    if [ -f "$config_file" ]; then
        echo "검사 중: $config_file"

        # 파일 내에서 ServerTokens Prod 및 ServerSignature Off 확인
        uncommented_content=$(grep -vE '^[[:space:]]*#' "$config_file")  # 주석 제거

        # ServerTokens Prod와 ServerSignature Off 확인
        if echo "$uncommented_content" | grep -qiE "ServerTokens\s+Prod" && \
           echo "$uncommented_content" | grep -qiE "ServerSignature\s+Off"; then
            echo "$config_file 파일에서 ServerTokens Prod 및 ServerSignature Off 설정이 모두 확인되었습니다."
            echo "----------------------------------------"
            echo "$uncommented_content" | grep -iE "ServerTokens|ServerSignature"
            echo "----------------------------------------"
            result=0
            break
        fi

        # <Directory> 블록 내 ServerTokens가 주석 처리된 경우 확인
        directory_blocks=$(awk '/<Directory/,/<\/Directory>/' "$config_file")
        if echo "$directory_blocks" | grep -qiE '#.*ServerTokens'; then
            echo "$config_file 파일에서 <Directory> 블록 내 ServerTokens 설정이 주석 처리되어 있습니다."
            echo "----------------------------------------"
            echo "$directory_blocks" | grep -iE '#.*ServerTokens'
            echo "----------------------------------------"
            result=1
            break
        fi

        # 주석된 설정이 있는지 확인
        commented_content=$(grep -iE "#.*(ServerTokens\s+Prod|ServerSignature\s+Off)" "$config_file" 2>/dev/null)
        if [ -n "$commented_content" ]; then
            echo "$config_file 파일에서 설정이 주석 처리되어 있습니다:"
            echo "----------------------------------------"
            echo "$commented_content"
            echo "----------------------------------------"
        else
            echo "$config_file 파일에서 ServerTokens Prod 및 ServerSignature Off 설정이 누락되었습니다."
        fi
    fi
done

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "httpd.conf 또는 apache*.conf 설정 파일에서 ServerTokens Prod 및 ServerSignature Off 설정을 확인하고 수정해주세요."
    echo "확인이 필요한 파일: httpd.conf, apache*.conf"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.35 Apache 웹 서비스 정보 숨김 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi