# !/bin/sh

# /etc/group 파일 확인
if [ -f "/etc/group" ]; then
    echo "GID가 500 이상, 포함 된 사용자가 없는 그룹의 목록:"
    echo "----------------------------------------"
    empty_groups=$(cat /etc/group | awk -F: '$3 >= 500 && $4 == "" {print $1}')
    
    if [ -n "$empty_groups" ]; then
        echo "$empty_groups"
        echo "----------------------------------------"
        echo "조건이 확인되지 않았습니다. exit 1"
        echo "출력 된 결과를 확인 후 불필요한 그룹을 제거해주세요."
        echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.12 계정이 존재하지 않는 GID 금지"
        echo "확인이 필요한 OS - LINUX"
        exit 1
    else
        echo "조건에 맞는 그룹이 없습니다."
        echo "조건이 확인되었습니다. exit 0"
        exit 0
    fi
else
    echo "/etc/group 파일이 존재하지 않습니다."
    echo "파일 경로를 확인하고 조치를 취해주세요."
    exit 1
fi