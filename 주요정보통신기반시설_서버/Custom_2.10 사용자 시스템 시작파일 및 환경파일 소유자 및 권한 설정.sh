# !/bin/sh

# 확인할 파일 패턴
file_patterns="\
.profile \
.exrc \
.netrc \
.kshrc \
.cshrc \
.bashrc \
.bash_profile \
.login"

# 기본 결과값
result=0

# 환경변수 파일 검색 및 확인
for file in $(find / -type f \( -name ".profile" -o -name ".exrc" -o -name ".netrc" -o -name ".kshrc" -o -name ".cshrc" -o -name ".bashrc" -o -name ".bash_profile" -o -name ".login" \) 2>/dev/null); do

    # 파일 존재 여부 확인
    if [ ! -e "$file" ]; then
        echo "$file: 파일이 존재하지 않습니다. 경로를 확인해주세요."
        continue
    fi

    # 파일 소유자 확인
    owner_name=$(ls -l "$file" 2>/dev/null | awk '{print $3}')
    if [ -z "$owner_name" ]; then
        echo "$file: 소유자를 확인할 수 없습니다."
        result=1
        continue
    fi

    # 파일 권한 확인
    permissions=$(ls -l "$file" 2>/dev/null | cut -d' ' -f1 | sed 's/^-//')
    if [ -z "$permissions" ]; then
        echo "$file: 권한을 확인할 수 없습니다."
        result=1
        continue
    fi

    # 조건 확인: 소유자가 root가 아닌 경우 또는 o+w 권한이 있는 경우
    if [ "$owner_name" != "root" ]; then
        echo "$file: 소유자가 root가 아닙니다."
        result=1
    elif echo "$permissions" | grep -q '.....w'; then
        echo "$file: o+w 권한이 설정되어 있습니다."
        result=1
    else
        echo "$file: 정상"
    fi
done

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "환경파일 소유자가 root가 아니거나, 일반 사용자에게 쓰기 권한이 부여되어 있습니다."
    echo "환경파일 소유자가 root가 아닌경우, 정상적인 소유자가 지정되어 있는지 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.10 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi