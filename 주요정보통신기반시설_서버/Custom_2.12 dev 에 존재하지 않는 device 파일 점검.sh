# !/bin/sh

# 기본 결과값
result=0

# /dev 디렉토리에서 일반 파일 검색
search_result=$(find /dev -type f -exec ls -l {} \; 2>/dev/null)

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
    echo "/dev 디렉토리에 일반 파일이 존재합니다. 파일을 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.12 /dev 에 존재하지 않는 device 파일 점검"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi