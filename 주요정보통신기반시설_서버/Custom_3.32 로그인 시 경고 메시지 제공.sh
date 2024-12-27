# !/bin/sh

# 조건 확인 결과
result=0

# /etc/motd 파일 내용 확인
motd=$(grep -Ei '.' /etc/motd 2>/dev/null || echo "")
# /etc/default/telnetd 파일에서 BANNER= 확인
telnetd_banner=$(grep -Ei "^\s*BANNER=" /etc/default/telnetd 2>/dev/null || echo "")
# /etc/default/ftpd 파일에서 BANNER= 확인
ftpd_banner=$(grep -Ei "^\s*BANNER=" /etc/default/ftpd 2>/dev/null || echo "")
# /etc/mail/sendmail.cf 파일에서 O SmtpGreetingMessage= 확인
sendmail_banner=$(grep -Ei "^\s*O[[:space:]]*SmtpGreetingMessage=" /etc/mail/sendmail.cf 2>/dev/null || echo "")
# /etc/named.conf 파일 내용 확인
named_conf=$(grep -Ei '.' /etc/named.conf 2>/dev/null || echo "")
# /etc/issue.net 파일 내용 확인
issue_net=$(grep -Ei '.' /etc/issue.net 2>/dev/null || echo "")
# /etc/vsftpd/vsftpd.conf 파일에서 ftpd_banner= 확인
vsftpd_banner=$(grep -Ei "^\s*ftpd_banner=" /etc/vsftpd/vsftpd.conf 2>/dev/null || echo "")

# 결과 확인
if [ -n "$motd" ]; then
    echo "/etc/motd 내용:"
    echo "$motd"
    result=1
else
    echo "/etc/motd 파일이 존재하지 않거나 내용이 없습니다."
    result=1
fi

if [ -n "$telnetd_banner" ]; then
    echo "/etc/default/telnetd 파일의 BANNER= 구문:"
    echo "$telnetd_banner"
    result=1
else
    echo "/etc/default/telnetd 파일이 존재하지 않거나 BANNER= 구문이 없습니다."
    result=1
fi

if [ -n "$ftpd_banner" ]; then
    echo "/etc/default/ftpd 파일의 BANNER= 구문:"
    echo "$ftpd_banner"
    result=1
else
    echo "/etc/default/ftpd 파일이 존재하지 않거나 BANNER= 구문이 없습니다."
    result=1
fi

if [ -n "$sendmail_banner" ]; then
    echo "/etc/mail/sendmail.cf 파일의 O SmtpGreetingMessage= 구문:"
    echo "$sendmail_banner"
    result=1
else
    echo "/etc/mail/sendmail.cf 파일이 존재하지 않거나 O SmtpGreetingMessage= 구문이 없습니다."
fi

if [ -n "$named_conf" ]; then
    echo "/etc/named.conf 내용:"
    echo "$named_conf"
    result=1
else
    echo "/etc/named.conf 파일이 존재하지 않거나 내용이 없습니다."
    result=1
fi

if [ -n "$issue_net" ]; then
    echo "/etc/issue.net 내용:"
    echo "$issue_net"
    result=1
else
    echo "/etc/issue.net 파일이 존재하지 않거나 내용이 없습니다."
    result=1
fi

if [ -n "$vsftpd_banner" ]; then
    echo "/etc/vsftpd/vsftpd.conf 파일의 ftpd_banner= 구문:"
    echo "$vsftpd_banner"
    result=1
else
    echo "/etc/vsftpd/vsftpd.conf 파일이 존재하지 않거나 ftpd_banner= 구문이 없습니다."
    result=1
fi

# 최종 결과 반환
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "Banner Message 를 설정해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.32 로그인 시 경고 메시지 제공"
    echo "확인이 필요한 OS - LINUX, SOLARIS"
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi