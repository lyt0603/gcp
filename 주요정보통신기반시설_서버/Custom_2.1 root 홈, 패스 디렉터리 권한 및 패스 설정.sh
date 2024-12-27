# !/bin/sh

# 디버깅을 위해 PATH 내용을 출력
echo "현재 PATH: $PATH"

# $PATH 검사: .:, ::, :.:, ., ./ 포함 여부 확인
if echo "$PATH" | grep -Eq '(^|:)\.:|(^|:)::|:.:|(^|:)\.$|(^|:)\./|\.'; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.1 root 홈, 패스 디렉터리 권한 및 패스 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi

# 모든 조건 통과
echo "조건이 확인되었습니다. exit 0"
exit 0