# !/bin/sh

# 기본 결과값
result=0

# UID별 계정 중복 확인
duplicate_accounts=$(awk -F: '
{
    count[$3]++;
    accounts[$3] = (accounts[$3] ? accounts[$3] "," $1 : $1);
}
END {
    for (uid in count) {
        if (count[uid] > 1) {
            print "UID: " uid ", Accounts: " accounts[uid];
        }
    }
}' /etc/passwd)

# 중복된 UID 출력
if [ -n "$duplicate_accounts" ]; then
    echo "UID가 중복된 계정 목록:"
    echo "----------------------------------------"
    echo "$duplicate_accounts"
    echo "----------------------------------------"
    echo "조건이 확인되지 않았습니다. exit 1"
    result=1
else
    echo "UID가 중복된 계정이 없습니다. 조건이 충족되었습니다. exit 0"
    result=0
fi

# 최종 결과 반환
if [ $result -eq 1 ]; then
    echo "중복된 UID를 확인하고 UID를 수정해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.13 동일한 UID 금지"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
else
    exit 0
fi