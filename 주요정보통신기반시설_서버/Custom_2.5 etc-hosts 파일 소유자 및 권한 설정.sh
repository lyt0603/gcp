# !/bin/sh

# 기본 결과값
result=0

# 권한 계산 함수
calculate_permissions() {
    file_permissions=$1
    numeric_permissions=0

    owner_permissions=$(echo "$file_permissions" | cut -c2-4)
    group_permissions=$(echo "$file_permissions" | cut -c5-7)
    other_permissions=$(echo "$file_permissions" | cut -c8-10)

    # 소유자 권한
    [ "$(echo "$owner_permissions" | cut -c1)" = "r" ] && numeric_permissions=$((numeric_permissions + 400))
    [ "$(echo "$owner_permissions" | cut -c2)" = "w" ] && numeric_permissions=$((numeric_permissions + 200))
    [ "$(echo "$owner_permissions" | cut -c3)" = "x" ] && numeric_permissions=$((numeric_permissions + 100))
    [ "$(echo "$owner_permissions" | cut -c3)" = "s" ] && numeric_permissions=$((numeric_permissions + 4100))
    [ "$(echo "$owner_permissions" | cut -c3)" = "S" ] && numeric_permissions=$((numeric_permissions + 4000))

    # 그룹 권한
    [ "$(echo "$group_permissions" | cut -c1)" = "r" ] && numeric_permissions=$((numeric_permissions + 40))
    [ "$(echo "$group_permissions" | cut -c2)" = "w" ] && numeric_permissions=$((numeric_permissions + 20))
    [ "$(echo "$group_permissions" | cut -c3)" = "x" ] && numeric_permissions=$((numeric_permissions + 10))
    [ "$(echo "$group_permissions" | cut -c3)" = "s" ] && numeric_permissions=$((numeric_permissions + 2010))
    [ "$(echo "$group_permissions" | cut -c3)" = "S" ] && numeric_permissions=$((numeric_permissions + 2000))

    # 기타 사용자 권한
    [ "$(echo "$other_permissions" | cut -c1)" = "r" ] && numeric_permissions=$((numeric_permissions + 4))
    [ "$(echo "$other_permissions" | cut -c2)" = "w" ] && numeric_permissions=$((numeric_permissions + 2))
    [ "$(echo "$other_permissions" | cut -c3)" = "x" ] && numeric_permissions=$((numeric_permissions + 1))
    [ "$(echo "$other_permissions" | cut -c3)" = "t" ] && numeric_permissions=$((numeric_permissions + 1001))
    [ "$(echo "$other_permissions" | cut -c3)" = "T" ] && numeric_permissions=$((numeric_permissions + 1000))

    echo "$numeric_permissions"
}

# /etc/hosts 파일 검사
hosts_file="/etc/hosts"

if [ -f "$hosts_file" ]; then
    echo "파일 경로: $hosts_file"

    # 파일 소유자 확인
    file_owner=$(ls -ld "$hosts_file" | awk '{print $3}')
    if [ "$file_owner" != "root" ]; then
        echo "$hosts_file: 소유자가 root가 아닙니다. 소유자: $file_owner"
        result=1
    fi

    # 파일 권한 확인
    file_permissions=$(ls -ld "$hosts_file" | awk '{print $1}')
    numeric_permissions=$(calculate_permissions "$file_permissions")

    # 권한을 숫자로 나누기
    owner=$(echo "$numeric_permissions" | awk '{print int($1/100) % 10}')
    group=$(echo "$numeric_permissions" | awk '{print int($1/10) % 10}')
    other=$(echo "$numeric_permissions" | awk '{print int($1) % 10}')
    special=$(echo "$numeric_permissions" | awk '{print int($1/1000)}')

    # 기본값 설정
    owner=${owner:-0}
    group=${group:-0}
    other=${other:-0}
    special=${special:-0}

    # 조건 확인: 특수권한 없음, owner <= 6, group == 0, other == 0
    if [ "$special" -eq 0 ] && [ "$owner" -le 6 ] && [ "$group" -eq 0 ] && [ "$other" -eq 0 ]; then
        echo "$hosts_file: 조건이 충족되었습니다."
    else
            echo "$hosts_file: 권한이 잘못 설정되었습니다. 권한: $file_permissions ($numeric_permissions)"
        result=1
    fi
else
    echo "$hosts_file: 파일이 존재하지 않습니다."
    result=1
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 충족되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/hosts 권한이 600 이하가 아니거나, 소유자가 root가 아닙니다."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.5 hosts 파일 소유자 및 권한 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi