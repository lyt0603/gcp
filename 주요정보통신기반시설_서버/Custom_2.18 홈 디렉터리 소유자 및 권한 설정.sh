# !/bin/sh

# 기본 결과값
result=0

# /etc/passwd에서 각 계정의 홈 디렉터리 추출
while IFS=: read -r username _ _ _ _ home_directory _; do
    if [ -d "$home_directory" ]; then
        # 디렉터리 소유자 확인
        dir_owner=$(ls -ld "$home_directory" | awk '{print $3}')

        # 디렉터리 권한 확인
        permissions=$(ls -ld "$home_directory" | awk '{print $1}')

        # 소유자가 본인 또는 root가 아닌 경우 처리
        if [ "$dir_owner" != "$username" ] && [ "$dir_owner" != "root" ]; then
            echo "홈 디렉터리 소유자가 본인 또는 root가 아닙니다:"
            echo "사용자: $username, 홈 디렉터리: $home_directory, 소유자: $dir_owner"
            result=1
        fi

        # other에 write 권한이 있는 경우 처리
        if echo "$permissions" | grep -q ".....w...."; then
            echo "홈 디렉터리에 other에 write 권한이 있습니다:"
            echo "사용자: $username, 홈 디렉터리: $home_directory, 권한: $permissions"
            result=1
        fi
    else
        echo "홈 디렉터리가 존재하지 않습니다: $home_directory (사용자: $username)"
    fi
done < /etc/passwd

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "사용자 별 홈 디렉터리 확인 후 소유자 및 권한을 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.18 홈 디렉터리 소유자 및 권한 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"   
    exit 1
fi