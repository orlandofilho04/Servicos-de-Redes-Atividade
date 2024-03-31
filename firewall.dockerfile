FROM ubuntu:latest

# Instalar servidor de firewall
RUN apt-get update && \
    apt-get install -y iptables && \
    apt-get install -y dnsutils && \
    apt-get install -y net-tools && \
    apt install -y telnet

# Copiar o script de firewall
COPY ./firewall_rules.sh /root/firewall_rules.sh

# Definir o script de firewall como executável
RUN chmod 755 /root/firewall_rules.sh

# Exemplo de regra de firewall
CMD ["/bin/bash", "-c", "/root/firewall_rules.sh; sleep infinity"]