# !/bin/sh

# Linux RHEL7 조건
linux_rhel7=$(grep -Ei "minlen=[8-9][0-9]*[[:space:]]+lcredit=-[1-9][0-9]*[[:space:]]+ucredit=-[1-9][0-9]*[[:space:]]+dcredit=-[1-9][0-9]*[[:space:]]+ocredit=-[1-9][0-9]*[[:space:]]+difok=N" /etc/security/pwquality.conf 2>/dev/null || echo "")
# Linux RHEL5 조건
linux_rhel5=$(grep -Ei "minlen=[8-9][0-9]*[[:space:]]+lcredit=-[1-9][0-9]*[[:space:]]+ucredit=-[1-9][0-9]*[[:space:]]+dcredit=-[1-9][0-9]*[[:space:]]+ocredit=-[1-9][0-9]*[[:space:]]+difok=N" /etc/pam.d/system-auth 2>/dev/null || echo "")
# AIX 조건
aix=$(grep -Ei "minlen=[8-9][0-9]*[[:space:]]+minother=[2-9][0-9]*[[:space:]]+minalpha=[2-9][0-9]*[[:space:]]+mindiff=[4-9][0-9]*[[:space:]]+maxrepeats=[2-9][0-9]*" /etc/security/user 2>/dev/null || echo "")
# Solaris 조건
solaris=$(grep -Ei "passlength=[8-9][0-9]*[[:space:]]+MINDIFF=[4-9][0-9]*[[:space:]]+MINALPHA=[1-9][0-9]*[[:space:]]+MINNONALPHA=[1-9][0-9]*[[:space:]]+MINUPPER=[1-9][0-9]*[[:space:]]+MINLOWER=[1-9][0-9]*[[:space:]]+MAXREPEATS=0[[:space:]]+MINSPECIAL=[1-9][0-9]*[[:space:]]+MINDIGIT=[1-9][0-9]*[[:space:]]+NAMECHECK=YES" /etc/default/passwd 2>/dev/null || echo "")
# HP-UX 조건
hp_ux=$(grep -Ei "MIN_PASSWORD_LENGTH=[8-9][0-9]*[[:space:]]+PASSWORD_MIN_UPPER_CASE_CHARS=[1-9][0-9]*[[:space:]]+PASSWORD_MIN_LOWER_CASE_CHARS=[1-9][0-9]*[[:space:]]+PASSWORD_MIN_DIGIT_CHARS=[1-9][0-9]*[[:space:]]+PASSWORD_MIN_SPECIAL_CHARS=[1-9][0-9]*" /etc/default/security 2>/dev/null || echo "")
# 조건 확인 및 결과 출력
if [ -n "$linux_rhel5" ] || [ -n "$linux_rhel7" ] || [ -n "$aix" ] || [ -n "$solaris" ] || [ -n "$hp_ux" ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.2 패스워드 복잡성 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi