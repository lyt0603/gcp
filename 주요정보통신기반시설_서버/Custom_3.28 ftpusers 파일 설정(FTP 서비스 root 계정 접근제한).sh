# !/bin/sh

# 기본 결과값
result=0

# FTP 관련 프로세스 검사
ps_ftp_processes=$(ps -ef | grep -E "proftpd|vsftpd|ftp" | grep -v "grep --color=auto" | grep -v "grep")

if [ -n "$ps_ftp_processes" ]; then
    echo "FTP 관련 프로세스가 실행 중입니다:"
    echo "----------------------------------------"
    echo "$ps_ftp_processes"
    echo "----------------------------------------"
else
    echo "FTP 관련 프로세스가 실행 중이지 않습니다. exit 0"
    exit 0
fi

# 검사할 파일 목록
files_to_check="/etc/ftpusers /etc/ftpd/ftpusers /etc/vsftpd/ftpusers /etc/vsftpd/user_list /etc/vsftpd.ftpusers /etc/vsftpd.user_list /etc/proftpd.conf"

# 파일 내용 검사
for file in $files_to_check; do
    if [ -f "$file" ]; then
        # 파일에서 root 또는 RootLogin on 확인
        file_matches=$(grep -iE "^\s*root\s*$|^\s*RootLogin\s+on\s*" "$file" 2>/dev/null)

        if [ -n "$file_matches" ]; then
            echo "다음 파일에 root 또는 RootLogin 설정이 존재합니다."
            echo "파일: $file"
            echo "----------------------------------------"
            echo "$file_matches"
            echo "----------------------------------------"
            result=1
        fi
    fi
done

# 최종 결과 반환
if [ $result -eq 1 ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "ftpusers 파일 내용중 root 또는 RootLogin 이 설정되어 있는 경우 제거해주세요."
    echo "확인이 필요한 파일: /etc/ftpusers, /etc/ftpd/ftpusers, /etc/vsftpd/ftpusers, /etc/vsftpd/user_list, /etc/vsftpd.ftpusers, /etc/vsftpd.user_list, /etc/proftpd.conf"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 3.28 ftpusers 파일 설정(FTP 서비스 root 계정 접근제한 )"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi