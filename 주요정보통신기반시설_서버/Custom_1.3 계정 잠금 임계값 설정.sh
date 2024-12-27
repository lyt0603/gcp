# !/bin/sh

# 각 조건에서 grep 결과가 비어 있으면 명시적으로 처리
retries_output=$(grep -Ei "^RETRIES=[0-9]+$" /etc/default/login 2>/dev/null | awk -F'=' '{if ($2 <= 10) print $0}' || echo "")
lock_after_retries_output=$(grep -Ei "^LOCK_AFTER_RETRIES=YES$" /etc/security/policy.conf 2>/dev/null || echo "")
pam_tally_auth=$(grep -Ei "^auth[[:space:]]+required[[:space:]]+/lib/security/pam_tally.so.*deny=[0-9]+.*no_magic_root" /etc/pam.d/system-auth 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i ~ /^deny=[0-9]+$/) {split($i, a, "="); if (a[2] <= 10) print $0}}' || echo "")
pam_tally_auth_and_account=$(grep -Ei "^auth[[:space:]]+required[[:space:]]+/lib/security/pam_tally.so.*deny=[0-9]+.*no_magic_root" /etc/pam.d/system-auth 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i ~ /^deny=[0-9]+$/) {split($i, a, "="); if (a[2] <= 10) print $0}}' && \
grep -Ei "^account[[:space:]]+required[[:space:]]+/lib/security/pam_tally.so.*no_magic_root.*reset" /etc/pam.d/system-auth 2>/dev/null || echo "")
login_retries_condition=$(grep -Ei "^loginretries=[0-9]+$" /etc/security/user 2>/dev/null | awk -F'=' '{if ($2 <= 10) print $0}' || echo "")
u_maxtries_condition=$(grep -Ei "^u_maxtries#[0-9]+$" /tcb/files/auth/system/default 2>/dev/null | awk -F'#' '{if ($2 <= 10) print $0}' || echo "")
auth_maxtries_condition=$(grep -Ei "^AUTH_MAXTRIES=[0-9]+$" /etc/default/security 2>/dev/null | awk -F'=' '{if ($2 <= 10) print $0}' || echo "")

# 디버깅용 출력
# echo "lock_after_retries_output: $lock_after_retries_output"

# 조건 확인 및 처리
if [ -n "$retries_output" ] || [ -n "$lock_after_retries_output" ] || \
   [ -n "$pam_tally_auth_and_account" ] || [ -n "$pam_tally_auth" ] || \
   [ -n "$login_retries_condition" ] || [ -n "$u_maxtries_condition" ] || \
   [ -n "$auth_maxtries_condition" ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.3 계정 잠금 임계값 설정"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi