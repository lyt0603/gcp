# !/bin/sh

# 기본 결과값
result=0

# World Writable 파일 검색
search_result=$(find / -type f -perm -0002 \
    -not -path "/proc/*" \
    -not -path "/sys/*" \
    -not -path "/dev/*" \
    -not -path "/run/*" \
    -not -path "/tmp/*" \
    -not -path "/var/tmp/*" \
    -not -path "/var/log/*" \
    -not -path "/var/run/*" \
    -exec ls -l {} \; 2>/dev/null)

# 검색 결과 확인
if [ -n "$search_result" ]; then
    echo "$search_result"
    result=1
else
    echo "조건이 확인되었습니다. exit 0"
    result=0
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo '"/proc", "/sys", "/dev", "/run", "/tmp", "/var/tmp", "/var/log", "/var/run" 경로를 제외한 결과값입니다.'
    echo "world writable 파일 존재 여부를 확인하고 불필요한 경우 제거해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.11 world writable"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi