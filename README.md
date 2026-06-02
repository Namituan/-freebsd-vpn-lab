# FreeBSD VPN Server - Ячейка 8

## Описание
FreeBSD 14.2 VPN-сервер с WireGuard, pf и Unbound DoT.

## Компоненты
- WireGuard VPN (подсеть 10.200.200.0/24, порт 51820)
- pf firewall (NAT + redirect DNS + block)
- Unbound DoT резолвер (Cloudflare 1.1.1.1:853, Quad9 9.9.9.9:853)

## Установка
1. Установи FreeBSD 14.2
2. Склонируй репозиторий:
   git clone https://github.com/Namituan/freebsd-vpn-lab.git
3. Запусти скрипт:
   cd freebsd-vpn-lab
   sh install.sh
4. Скрипт выведет ключи для клиента

## Конфиг клиента Windows
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.200.200.2/32
DNS = 10.200.200.1

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = СЕРВЕР_IP:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
