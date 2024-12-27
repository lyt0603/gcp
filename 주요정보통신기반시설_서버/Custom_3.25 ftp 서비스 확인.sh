# !/bin/sh

# 기본 결과값
result=0

# ps -ef | grep proftpd
ps_proftpd_result=$(ps -ef | grep proftpd | grep -v "grep --color=auto" | grep -v "grep")
if [ -n "$ps_proftpd_result" ]; then
    echo "ps -ef | grep proftpd 결과:"
    echo "----------------------------------------"
    echo "$ps_proftpd_result"
    echo "----------------------------------------"
    result=1
fi

# ps -ef | grep vsftpd
ps_vsftpd_result=$(ps -ef | grep vsftpd | grep -v "grep --color=auto" | grep -v "grep")
if [ -n "$ps_vsftpd_result" ]; then
    echo "ps -ef | grep vsftpd 결과:"
    echo "----------------------------------------"
    echo "$ps_vsftpd_result"
    echo "----------------------------------------"
    result=1
fi

# ps -ef | grep ftp
ps_grep_ftp_result=$(ps -ef | grep ftp | grep -v "grep --color=auto" | grep -v "grep")
if [ -n "$ps_grep_ftp_result" ]; then
    echo "ps -ef | grep ftp 결과:"
    echo "----------------------------------------"
    echo "$ps_grep_ftp_result"
    echo "----------------------------------------"
    result=1
fi

# 최종 결과 반환
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "FTP 관련 프로세스가 확인되었습니다. 내용을 확인 후 서비스를 비활성화 해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.25 ftp 서비스 확인"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"   
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi