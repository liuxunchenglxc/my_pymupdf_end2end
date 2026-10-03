echo "test tesseract"
tesseract --list-langs

#### $1 bzid
#### $2 dir_id

echo "test buzzheavier"
python -u buzzheavier.py $1 $2

echo "test scanner"
python -u scanner.py $1

echo "IP test"

###
echo "=== 开始检测网络架构 ==="

# 1. 检查 IPv4 NAT 情况
local_ipv4=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1)
public_ipv4=$(curl -s4 --connect-timeout 5 ifconfig.me)

if [ -n "$public_ipv4" ]; then
    echo "探测到 IPv4 出口公网: $public_ipv4"
    echo "本地网卡 IPv4 地址: $local_ipv4"
    if [ "$local_ipv4" = "$public_ipv4" ]; then
        echo "--> [IPv4 结果]: 恭喜，是【原生公网 IP】，未经过 NAT 直连！"
    else
        echo "--> [IPv4 结果]: 存在【NAT 转换】，公网 IP 与网卡 IP 不一致。"
    fi
else
    echo "--> [IPv4 结果]: 无法连接 IPv4 公网（可能无网络或被防火墙拦截）。"
fi

echo "--------------------------------------"

# 2. 检查 IPv6 NAT 情况
# 过滤掉环回地址(::1)和链路本地地址(fe80::)
local_ipv6=$(ip -6 addr show | grep -oP '(?<=inet6\s)[0-9a-fA-F:]+' | grep -v '^::1' | grep -v '^fe80' | head -n 1)
public_ipv6=$(curl -s6 --connect-timeout 5 ifconfig.me)

if [ -n "$public_ipv6" ]; then
    echo "探测到 IPv6 出口公网: $public_ipv6"
    echo "本地网卡 IPv6 地址: $local_ipv6"
    if [ "$local_ipv6" = "$public_ipv6" ]; then
        echo "--> [IPv6 结果]: 恭喜，是【原生公网 IPv6】，无 NAT 直连！"
    else
        echo "--> [IPv6 结果]: 存在【IPv6 NAT 转换】（常见于某些内网 Docker 或特殊路由器环境）。"
    fi
else
    echo "--> [IPv6 结果]: 无法连接 IPv6 公网。"
fi
###
