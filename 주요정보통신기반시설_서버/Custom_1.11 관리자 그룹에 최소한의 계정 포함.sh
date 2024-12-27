# !/bin/sh

# /etc/group 파일 확인
if [ -f "/etc/group" ]; then
    echo "/etc/group 파일의 전체 내용:"
    echo "----------------------------------------"
    cat /etc/group
    echo "----------------------------------------"
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "/etc/group 파일의 내용을 확인 후 관리자 그룹에 불필요한 계정이 등록되어있는지 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.11 관리자 그룹에 최소한의 계정 포함"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "/etc/group 파일이 존재하지 않습니다."
    echo "파일 경로를 확인하고 조치를 취해주세요."
    exit 1
fi