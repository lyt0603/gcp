# !/bin/sh

# 기본 결과값
result=1

# umask 설정 확인 함수
check_umask() {
    file=$1
    if [ -f "$file" ]; then
        umask_values=$(grep -i "umask" "$file" | grep -vE "^[[:space:]]*#")
        if [ -n "$umask_values" ]; then
            echo "$file 파일에서 발견된 umask 설정:"
            echo "----------------------------------------"
            echo "$umask_values"
            echo "----------------------------------------"
            for value in $(echo "$umask_values" | awk '{print $NF}'); do
                if [ "$value" -ge 22 ]; then
                    result=0
                else
                    echo "$file 파일의 umask 설정이 022 미만입니다. 설정된 값: $value"
                    result=1
                fi
            done
        fi
    fi
}

# 경로 목록
files_to_check="/etc/profile /etc/bash.bashrc /etc/profile.d/*.sh ~/.bashrc ~/.bash_profile ~/.profile"

# 각 파일에서 umask 확인
for file in $files_to_check; do
    check_umask "$file"
done

# 현재 셸의 umask 값 확인
current_umask=$(umask)
echo "현재 셸의 umask 값: $current_umask"

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 파일의 umask 설정이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "파일에 umask 설정이 없거나, 022 미만인 설정이 있습니다. umask 설정을 확인하고 수정해주세요. (022 이상)"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.17 UMASK 설정 관리"
    echo "확인이 필요한 OS - LINUX, SOLARIS, AIX, HP-UX"
    exit 1
fi