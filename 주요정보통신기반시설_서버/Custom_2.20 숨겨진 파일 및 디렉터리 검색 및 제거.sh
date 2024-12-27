# !/bin/sh

# 기본 결과값
result=0

# 숨김 파일 점검
hidden_files=$(find / -type f -name ".*" 2>/dev/null)
if [ -n "$hidden_files" ]; then
    echo "다음 숨김 파일이 발견되었습니다:"
    echo "----------------------------------------"
    echo "$hidden_files"
    echo "----------------------------------------"
    result=1
else
    echo "숨김 파일이 발견되지 않았습니다."
fi

# 숨김 디렉터리 점검
hidden_dirs=$(find / -type d -name ".*" 2>/dev/null)
if [ -n "$hidden_dirs" ]; then
    echo "다음 숨김 디렉터리가 발견되었습니다:"
    echo "----------------------------------------"
    echo "$hidden_dirs"
    echo "----------------------------------------"
    result=1
else
    echo "숨김 디렉터리가 발견되지 않았습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "모든 조건이 확인되었습니다. 숨김 파일 및 디렉터리가 없습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "숨김 파일 및 디렉터리를 확인하고 조치를 취해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.20 숨겨진 파일 및 디렉터리 검색 및 제거"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"   
    exit 1
fi