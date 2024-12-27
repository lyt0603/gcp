# !/bin/sh

# SUID 또는 SGID 파일 검색
results=$(find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -l {} \; 2>/dev/null)

# 결과 확인 및 처리
if [ -n "$results" ]; then
    echo "$results"
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "SUID SGID 가 설정 된 파일 목록입니다. 불필요한 SUID/SGID를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.9 SUID, SGID, 설정 파일점검"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    echo "조건이 확인되었습니다. exit 0"
    exit 0
fi