#!/bin/bash

# I. Permitir tráfego para a interface de loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# II. Estabelecer a política DROP para INPUT e FORWARD
iptables -P INPUT DROP
iptables -P FORWARD DROP

# III. Permitir acesso à WWW (portas 80 e 443) para usuários internos com NAT
iptables -A FORWARD -i eth0 -o eth2 -s 10.1.1.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -s 10.1.1.0/24 -p tcp --dport 443 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth2 -s 10.1.1.0/24 -j MASQUERADE

# IV. Fazer LOG e bloquear acesso a sites contendo "games"
iptables -A FORWARD -m string --algo bm --string "games" -j LOG --log-prefix "Blocked Games: "
iptables -A FORWARD -m string --algo bm --string "games" -j DROP

# V. Bloquear acesso ao site www.jogosonline.com.br, exceto para o chefe
iptables -A FORWARD -d www.jogosonline.com.br -j DROP
iptables -A FORWARD -s 10.1.1.100 -d www.jogosonline.com.br -j ACCEPT

# VI. Permitir pacotes ICMP echo-request limitados a 5 por segundo
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/s -j ACCEPT

# VII. Permitir consultas DNS externas para a rede interna e DMZ
iptables -A FORWARD -i eth0 -o eth2 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p udp --dport 53 -j ACCEPT

# VIII. Permitir tráfego TCP para a máquina na DMZ na porta 80 de qualquer rede
iptables -A FORWARD -p tcp -d 192.168.1.100 --dport 80 -j ACCEPT

# IX. Redirecionar tráfego TCP para 200.20.5.1:80 para a máquina na DMZ
iptables -t nat -A PREROUTING -i eth2 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.100

# X. Permitir respostas da máquina na DMZ na porta 80
iptables -A FORWARD -p tcp -s 192.168.1.100 --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT
