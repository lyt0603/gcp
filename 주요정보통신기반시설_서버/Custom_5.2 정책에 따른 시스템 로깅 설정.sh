# !/bin/sh

# 기본 결과값
result=0

# syslog.conf 파일 검색
syslog_conf_file=$(find / -type f -name "syslog.conf" 2>/dev/null)

if [ -n "$syslog_conf_file" ]; then
    echo "syslog.conf 파일이 발견되었습니다:"
    echo "----------------------------------------"
    echo "$syslog_conf_file"
    echo "----------------------------------------"
    echo "파일 내용:"
    echo "----------------------------------------"
    cat "$syslog_conf_file"
    echo "----------------------------------------"
    result=1
else
    echo "syslog.conf 파일이 발견되지 않았습니다. exit 0"
    exit 0
fi

# 결과 반환
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "로그 기록 정책을 수립하고, 정책에 따라 syslog.conf 파일을 설정해주세요."    
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 5.2 정책에 따른 시스템 로깅 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi