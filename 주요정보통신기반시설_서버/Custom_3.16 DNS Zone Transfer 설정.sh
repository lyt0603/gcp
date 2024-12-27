# !/bin/sh

# 기본 결과값
result=0

# [1] named 프로세스 또는 DNS 관련 서비스 검사
process_or_service=$(ps -ef | grep "named" | grep -vE "grep|--color|egrep") || \
                     (command -v svcs >/dev/null 2>&1 && svcs -a | egrep "dns")

if [ -n "$process_or_service" ]; then
    echo "named 프로세스 또는 DNS 관련 서비스가 실행 중입니다."
    echo "$process_or_service"

    # named.conf 및 named.boot 파일 확인 (예외: 기본 경로 및 사용자 정의 경로의 named.conf 파일)
    named_files=$(find / -type f \( -name "named.conf" -o -name "named.boot" \) \
                  ! -path "/usr/lib/tmpfiles.d/named.conf" \
                  ! -path "/etc/tmpfiles.d/named.conf" 2>/dev/null)

    if [ -n "$named_files" ]; then
        for file in $named_files; do
            echo "파일 경로: $file"

            # allow-transfer 또는 xfrnets 설정 확인 (주석 제외)
            transfer_config=$(grep -vE '^[[:space:]]*#' "$file" | grep -E 'allow-transfer|xfrnets' 2>/dev/null)
            if [ -n "$transfer_config" ]; then
                echo "파일 내용에 'allow-transfer' 또는 'xfrnets' 설정이 확인되었습니다:"
                echo "----------------------------------------"
                echo "$transfer_config"
                echo "----------------------------------------"
            else
                echo "파일 내용에 'allow-transfer' 또는 'xfrnets' 설정이 존재하지 않습니다."
            fi
        done
        result=1
    else
        echo "named.conf 및 named.boot 파일이 시스템에 존재하지 않습니다."
        result=1
    fi
else
    echo "named 프로세스와 DNS 관련 서비스가 실행되고 있지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "named.conf 및 named.boot 파일을 확인하고 설정을 점검해주세요."
    echo "Zone Transfer 를 허용하고자 하는 IP 를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.16 DNS Zone Transfer 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi