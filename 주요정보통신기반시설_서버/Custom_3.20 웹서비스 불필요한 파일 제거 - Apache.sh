# !/bin/sh

# 기본 결과값
result=0

# manual 및 htdocs/manual 파일 또는 디렉터리 검색
manual_entries=$(find /etc /usr /var \( -type d -o -type f \) -name "manual" 2>/dev/null)

if [ -n "$manual_entries" ]; then
    echo "다음 경로에서 'manual' 또는 'htdocs/manual' 항목이 발견되었습니다:"
    echo "----------------------------------------"
    echo "$manual_entries"
    echo "----------------------------------------"
    result=1
else
    echo "'manual' 또는 'htdocs/manual' 항목이 시스템에 존재하지 않습니다."
    result=0
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "'manual' 또는 'htdocs/manual' 항목을 제거해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.20 웹서비스 불필요한 파일 제거 (Apache)"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"    
    exit 1
fi