# !/bin/sh

# 기본 결과값
result=0

# 1. iptables -L 확인 및 DROP 라인 출력
drop_lines=$(iptables -L 2>/dev/null | grep -E 'DROP' | grep -v 'Chain FORWARD (policy DROP)')
if [ -n "$drop_lines" ]; then
    echo "iptables 의 DROP IP를 확인해주세요."
    echo "$drop_lines"
    result=1
else
    echo "iptables -L: DROP 라인에 IP 가 존재하지 않습니다."
    result=1
fi

if [ ! -f /etc/hosts.allow ]; then
    echo "/etc/hosts.allow 파일이 존재하지 않습니다."
    result=1
fi

if [ ! -f /etc/hosts.deny ]; then
    echo "/etc/hosts.deny 파일이 존재하지 않습니다."
    result=1
fi

# 3. /etc/hosts.deny에 IP 또는 CIDR 출력
if [ -f /etc/hosts.deny ]; then
    deny_ips=$(grep -E '(([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?)' /etc/hosts.deny 2>/dev/null)

    if [ -n "$deny_ips" ]; then
        echo "/etc/hosts.deny 의 DROP IP를 확인해주세요."
        echo "$deny_ips"
        result=1
    else
        echo "/etc/hosts.deny 에 IP 가 존재하지 않습니다."
        result=1
    fi
fi

# 4. 최종 결과 반환
if [ $result -eq 0 ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else    
    echo "iptables, hosts.deny 에 명시 된 IP를 확인해주세요."
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 2.14 접속 IP 및 포트 제한"
    echo "확인이 필요한 OS - LINUX"
    exit 1
fi