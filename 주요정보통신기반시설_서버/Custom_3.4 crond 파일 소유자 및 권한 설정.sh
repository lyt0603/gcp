# !/bin/sh

# 기본 결과값
result=0  # 기본적으로 성공 상태

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

# 파일 검사 함수
check_file() {
    file=$1
    max_owner=$2
    max_group=$3
    max_other=$4
    check_owner=$5  # 파일 소유자 확인 여부
    file_issues=0

    if [ ! -e "$file" ]; then
        echo "$file: 파일이 존재하지 않습니다."
        return 0
    fi

    # 파일 소유자 확인 (옵션 적용)
    if [ "$check_owner" = "true" ]; then
        file_owner=$(ls -ld "$file" | awk '{print $3}')
        if [ "$file_owner" != "root" ]; then
            echo "$file: 소유자가 root가 아닙니다. 소유자: $file_owner"
            file_issues=1
        fi
    fi

    # 파일 권한 확인
    file_permissions=$(ls -ld "$file" | awk '{print $1}')
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

    # 조건 확인
    if ! ([ "$special" -eq 0 ] && [ "$owner" -le "$max_owner" ] && [ "$group" -le "$max_group" ] && [ "$other" -le "$max_other" ]); then
        echo "$file: 권한이 잘못 설정되었습니다. 권한: $file_permissions (owner=$owner, group=$group, other=$other)"
        file_issues=1
    fi

    # 파일 문제 여부 반환
    if [ "$file_issues" -eq 0 ]; then
        echo "$file: 조건이 충족되었습니다."
        return 0
    else
        return 1
    fi
}

# 경로 목록
cron_paths="/etc/cron.d /etc /var/adm/cron /var/spool/cron /var/spool/cron/crontabs"
cron_files="cron.hourly cron.daily cron.weekly cron.monthly cron.allow cron.deny"

# [1] crontab 파일 확인 (owner <= 7, group <= 5, other == 0)
for path in $cron_paths; do
    crontab_file="$path/crontab"
    if [ -e "$crontab_file" ]; then
        if ! check_file "$crontab_file" 7 5 0 false; then
            result=1
        fi
    fi
done

# [2] cron 파일들 확인 (owner <= 6, group <= 4, other == 0, 소유자 확인 포함)
for path in $cron_paths; do
    for file in $cron_files; do
        full_path="$path/$file"
        if [ -e "$full_path" ]; then
            if ! check_file "$full_path" 6 4 0 true; then
                result=1
            fi
        fi
    done
done

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 충족되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/cron.d /etc /var/adm/cron /var/spool/cron /var/spool/cron/crontabs 내 cron 파일의 소유자 및 권한을 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.4 crond 파일 소유자 및 권한 설정"
    echo "확인이 필요한 OS - LINUX, AIX, HP-UX"
    exit 1
fi