# !/bin/sh

# 기본 결과값
result=1

# ps -ax | grep sshd
ps_ax_result=$(ps -ax | grep sshd | grep -v "grep --color=auto" | grep -v "grep")
if [ -n "$ps_ax_result" ]; then
    echo "ps -ax | grep sshd 결과:"
    echo "----------------------------------------"
    echo "$ps_ax_result"
    echo "----------------------------------------"
    result=0
fi

# svcs -a | grep ssh
svcs_a_result=$(svcs -a 2>/dev/null | grep ssh | grep -v "grep --color=auto" | grep -v "grep")
if [ -n "$svcs_a_result" ]; then
    echo "svcs -a | grep ssh 결과:"
    echo "----------------------------------------"
    echo "$svcs_a_result"
    echo "----------------------------------------"
    result=0
fi

# ps -ef | grep sshd
ps_ef_result=$(ps -ef | grep sshd | grep -v "grep --color=auto" | grep -v "grep")
if [ -n "$ps_ef_result" ]; then
    echo "ps -ef | grep sshd 결과:"
    echo "----------------------------------------"
    echo "$ps_ef_result"
    echo "----------------------------------------"
    result=0
fi

# 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다 exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "SSH 관련 프로세스 또는 서비스가 확인되지 않았습니다. SSH 관련 프로세스 및 서비스 상태를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.24 ssh 원격접속 허용"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"   
    exit 1
fi