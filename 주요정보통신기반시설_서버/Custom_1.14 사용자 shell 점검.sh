# !/bin/sh

# 기본 결과값
result=0

# /etc/passwd에서 /sbin/nologin 또는 /usr/sbin/nologin이 아닌 쉘을 사용하는 계정 검색
non_nologin_accounts=$(cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | awk -F':' '$NF != "/sbin/nologin" && $NF != "/usr/sbin/nologin" && $NF != "/bin/false"')

if [ -n "$non_nologin_accounts" ]; then
    echo "다음 계정이 /sbin/nologin 또는 /usr/sbin/nologin이 아닌 쉘을 사용하고 있습니다:"
    echo "----------------------------------------"
    echo "$non_nologin_accounts"
    echo "----------------------------------------"
    result=1
else
    echo "모든 계정이 /sbin/nologin 또는 /usr/sbin/nologin 또는 /bin/false 로 설정되어 있습니다. 조건이 충족되었습니다."
    result=0
fi

# 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "로그인이 필요하지 않은 계정에 대해 /bin/false(/sbin/nologin) 쉘을 부여해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.14 사용자 shell 점검"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi