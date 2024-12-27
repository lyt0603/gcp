# !/bin/sh

# 기본 결과값
result=0

# /etc/passwd에서 각 계정의 홈 디렉터리 확인
while IFS=: read -r username _ _ _ _ home_directory _; do
    # 홈 디렉터리가 지정되지 않은 경우
    if [ -z "$home_directory" ]; then
        echo "사용자 '$username'의 홈 디렉터리가 지정되지 않았습니다."
        result=1
    elif [ ! -d "$home_directory" ]; then
        # 홈 디렉터리가 존재하지 않는 경우
        echo "사용자 '$username'의 홈 디렉터리가 존재하지 않습니다: $home_directory"
        result=1
    fi
done < /etc/passwd

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 사용자의 홈 디렉터리가 올바르게 지정되고 존재합니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "홈 디렉터리가 지정되지 않았거나, 존재하지 않는 사용자를 확인하고 조치를 취해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.19 홈 디렉터리로 지정한 디렉터리의 존재 관리"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"   
    exit 1
fi