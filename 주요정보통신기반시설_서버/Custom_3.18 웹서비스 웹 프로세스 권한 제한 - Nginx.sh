# !/bin/sh

# 기본 결과값
result=0

# Nginx 프로세스 확인
nginx_process=$(ps -ef | grep -i "nginx" | grep -v "grep")

if [ -n "$nginx_process" ]; then
    echo "Nginx 프로세스가 실행 중입니다:"
    echo "----------------------------------------"
    echo "$nginx_process"
    echo "----------------------------------------"
    result=1
else
    echo "Nginx 프로세스가 실행 중이지 않습니다."
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "Nginx 프로세스가 실행 중입니다. 프로세스의 실행 주체를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.18 웹서비스 웹 프로세스 권한 제한 (Nginx)"
    exit 1
fi