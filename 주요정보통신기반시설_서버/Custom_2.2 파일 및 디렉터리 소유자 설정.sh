#!/bin/sh

# 조건 확인
condition1=$(find / -nouser -o -nogroup -xdev -ls 2> /dev/null)
condition2=$(find / \( -nouser -o -nogroup \) -xdev -exec ls -al {} \; 2> /dev/null)
condition3=$(find / -nouser -print 2> /dev/null)
condition4=$(find / -nogroup -print 2> /dev/null)

# 조건 확인 및 처리
# 조건들 중에서 /로 시작하는 경로가 있는지 확인
matching_paths=$(printf "%s\n%s\n%s\n%s" "$condition1" "$condition2" "$condition3" "$condition4" | grep '^/')

if [ -n "$matching_paths" ]; then
    # /로 시작하는 경로가 있으면 경로를 출력하고 exit 1
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "출력된 리스트:"
    echo "$matching_paths"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.2 파일 및 디렉터리 소유자 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    # 출력값이 없거나 경로가 아닌 경우
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi