# !/bin/sh

# 각 조건에서 grep 결과가 비어 있으면 명시적으로 처리
solaris_telnet_output=$(grep -Ei "^CONSOLE=/dev/console" /etc/default/login 2>/dev/null || echo "")
linux_telnet1_output=$(grep -Ei "^auth[[:space:]]*required[[:space:]]*/lib/security/pam_securetty.so" /etc/pam.d/login 2>/dev/null || echo "")
linux_telnet2_output=$(grep -Ei "^pts" /etc/securetty 2>/dev/null || echo "")
aix_telnet_output=$(grep -Ei "^rlogin[[:space:]]*=[[:space:]]*false" /etc/security/user 2>/dev/null || echo "")
hp_ux_telnet_output=$(grep -Ei "^console" /etc/securetty 2>/dev/null || echo "")

# "^PermitRootLogin[[:space:]]*yes" 감지
permit_root_yes=$(grep -Ei "^PermitRootLogin[[:space:]]*yes" /etc/ssh/sshd_config 2>/dev/null || echo "")

# "^PermitRootLogin[[:space:]]*yes"가 감지되거나 "pts"가 감지되면 즉시 exit 1
if [ -n "$permit_root_yes" ] || [ -n "$linux_telnet2_output" ]; then
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.1 root 계정 원격접속 제한"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi

# 조건 확인
if { [ -n "$solaris_telnet_output" ] && [ -z "$permit_root_yes" ]; } || \
   { [ -n "$linux_telnet1_output" ] && [ -z "$linux_telnet2_output" ] && [ -z "$permit_root_yes" ]; } || \
   { [ -n "$aix_telnet_output" ] && [ -z "$permit_root_yes" ]; } || \
   { [ -n "$hp_ux_telnet_output" ] && [ -z "$permit_root_yes" ]; }; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.1 root 계정 원격접속 제한"
    echo "확인이 필요한 OS - SOLARIS, LINUX, AIX, HP-UX"
    exit 1
fi