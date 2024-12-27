# !/bin/sh

# 기본 결과값
result=0

# 권한 계산 함수는 기존 스크립트 그대로 사용
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

# [1] /etc/group에서 wheel 그룹 확인
if grep -q "^wheel:" /etc/group; then
    echo "/etc/group에서 wheel 그룹이 발견되었습니다."
else
    echo "/etc/group에서 wheel 그룹이 발견되지 않았습니다."
    result=1
fi

# [2] /usr/bin/su 파일 검사
if [ -f "/usr/bin/su" ]; then
    echo "파일 경로: /usr/bin/su"

    # 파일 소유자와 그룹 확인
    file_owner=$(ls -l /usr/bin/su | awk '{print $3}')
    file_group=$(ls -l /usr/bin/su | awk '{print $4}')
    echo "/usr/bin/su 파일의 소유자: $file_owner, 그룹: $file_group"

    if [ "$file_group" = "root" ]; then
        echo "/usr/bin/su 파일의 그룹이 root입니다."
        result=1
    fi

    # 파일 권한 확인
    file_permissions=$(ls -ld /usr/bin/su | awk '{print $1}')
    numeric_permissions=$(calculate_permissions "$file_permissions")

    # 권한 확인
    if [ "$numeric_permissions" -eq 4750 ]; then
        echo "/usr/bin/su 파일의 권한이 4750으로 설정되었습니다."
    else
        echo "/usr/bin/su 파일의 권한이 올바르게 설정되지 않았습니다."
        echo "권한: $file_permissions ($numeric_permissions)"
        result=1
    fi
else
    echo "/usr/bin/su 파일이 존재하지 않습니다."
    result=1
fi

# 최종 결과 출력 및 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/group에서 wheel 그룹 확인 및 /usr/bin/su 파일의 소유자, 그룹, 권한을 검토하세요."
    echo "주요 요구 사항: su 파일 권한은 4750, 소유자는 root, 그룹은 root가 아니어야 합니다."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.6 root 계정 su 제한"
    exit 1
fi