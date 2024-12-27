# !/bin/sh

# 조건 설정
shadow_file_condition=$(ls /etc | grep -q "^shadow$" && echo "yes" || echo "")
passwd_root_field_condition=$(grep -q "^root:x:" /etc/passwd && echo "yes" || echo "")

# 조건 확인 및 처리
if [ -n "$shadow_file_condition" ] && [ -n "$passwd_root_field_condition" ]; then
    echo "조건이 확인되었습니다. exit 0"
    exit 0
else
    echo "조건이 확인되지 않았습니다. exit 1"
    echo "주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드 - 1.4 패스워드 파일 보호"
    echo "확인이 필요한 OS - SOLARIS, LINUX"
    exit 1
fi