# !/bin/sh

# 기본 결과값
result=0

# 1. /etc/passwd 에서 "ftp" 계정 확인
ftp_account=$(grep "ftp" /etc/passwd 2>/dev/null)

if [ -n "$ftp_account" ]; then
    echo "etc/passwd 파일에 ftp 계정이 존재합니다."
    echo "$ftp_account"
    result=1
fi

# 2. vsftpd 설정 파일 검사
vsftpd_files="/etc/vsftpd/vsftpd.conf /etc/vsftpd.conf"
vsftpd_found=0

for file in $vsftpd_files; do
    if [ -f "$file" ]; then
        cat "$file"

        # anonymous_enable 설정 확인 (대소문자 구분없이 검사)
        anonymous_enable=$(grep -i "anonymous_enable" "$file" 2>/dev/null)

        if echo "$anonymous_enable" | grep -qi "anonymous_enable[[:space:]]*=[[:space:]]*yes"; then
            echo "$file 파일에서 anonymous_enable=yes 설정이 확인되었습니다."
            result=1
        elif echo "$anonymous_enable" | grep -qi "anonymous_enable[[:space:]]*=[[:space:]]*no"; then
            echo "$file 파일에서 anonymous_enable=no 설정이 확인되었습니다."
            vsftpd_found=1
        else
            echo "$file 파일에 anonymous_enable 설정이 존재하지 않습니다."
        fi
    fi
done

# 최종 결과 반환
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "ftp 계정 존재 여부 및 /etc/vsftpd/vsftpd.conf /etc/vsftpd.conf 파일에서 anonymous_enable 설정을 확인해주
세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.2 Anonymous FTP 비활성화"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi