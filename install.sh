#!/bin/sh
# Установка FreeBSD VPN сервера

echo "=== Установка wireguard-tools ==="
pkg install -y wireguard-tools ca_root_nss unbound

echo "=== Включение IP forwarding ==="
sysctl net.inet.ip.forwarding=1
echo "net.inet.ip.forwarding=1" >> /etc/sysctl.conf

echo "=== Генерация ключей ==="
mkdir -p /etc/wireguard
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
wg genkey | tee /etc/wireguard/client1_private.key | wg pubkey > /etc/wireguard/client1_public.key
chmod 600 /etc/wireguard/server_private.key
chmod 600 /etc/wireguard/client1_private.key

echo "=== Создание wg0.conf ==="
cat > /etc/wireguard/wg0.conf << WGEOF
[Interface]
Address = 10.200.200.1/24
ListenPort = 51820
PrivateKey = $(cat /etc/wireguard/server_private.key)

[Peer]
PublicKey = $(cat /etc/wireguard/client1_public.key)
AllowedIPs = 10.200.200.2/32
WGEOF
chmod 600 /etc/wireguard/wg0.conf

echo "=== Настройка WireGuard ==="
sysrc wireguard_enable="YES"
sysrc wireguard_interfaces="wg0"
service wireguard start

echo "=== Настройка pf ==="
cp /root/freebsd-vpn-lab/pf.conf /etc/pf.conf
sysrc pf_enable="YES"
kldload pf
pfctl -f /etc/pf.conf
pfctl -e

echo "=== Настройка Unbound ==="
cp /root/freebsd-vpn-lab/unbound.conf /usr/local/etc/unbound/unbound.conf
unbound -c /usr/local/etc/unbound/unbound.conf

echo "=== Готово! ==="
echo "Публичный ключ сервера:"
cat /etc/wireguard/server_public.key
echo "Приватный ключ клиента:"
cat /etc/wireguard/client1_private.key
echo "Публичный ключ клиента:"
cat /etc/wireguard/client1_public.key
