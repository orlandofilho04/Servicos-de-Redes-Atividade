## Firewall IPTABLES - Lista de Exercícios

Elabore as regras necessárias para implementar os seguintes controles. Utilize para isso as
regras do firewall Linux (netfilter/iptables).

1. Libere qualquer tráfego para interface de loopback no firewall.

2. Estabeleça a política DROP (restritiva) para as chains INPUT e FORWARD da tabela filter.

3. Possibilite que usuários da rede interna possam acessar o serviço WWW, tanto na porta (TCP) 80 como na 443. Não esqueça de realizar NAT já que os usuários internos não possuem um endereço IP válido.

4. Faça LOG e bloqueie o acesso a qualquer site que contenha a palavra “games”.

5. Bloqueie acesso para qualquer usuário ao site www.jogosonline.com.br, exceto para seu chefe, que possui o endereço IP 10.1.1.100.

6. Permita que o firewall receba pacotes do tipo ICMP echo-request (ping), porém, limite a 5 pacotes por segundo.

7. Permita que tanto a rede interna como a DMZ possam realizar consultas ao DNS externo, bem como, receber os resultados das mesmas.

8. Permita o tráfego TCP destinado à máquina 192.168.1.100 (DMZ) na porta 80, vindo de qualquer rede (Interna ou Externa).

9. Redirecione pacotes TCP destinados ao IP 200.20.5.1 porta 80, para a máquina 192.168.1.100 que está localizado na DMZ.

10. Faça com que a máquina 192.168.1.100 consiga responder os pacotes TCP recebidos na porta 80 corretamente.

Preste atenção, os serviços do tipo cliente x servidor, dependem de pacotes de respostas, sendo assim,
é necessário criar regras que aceitem os pacotes de respostas. Você pode também utilizar o módulo
state para realizar esta tarefa.

## Estrutura do Projeto

- firewall.dockerfile (arquivo de configuração necessário para criação do FIREWALL)
- firewall_rules.sh (arquivo necessário para configuração do FIREWALL)
- README.md (arquivo de instruções)

## Pré-requisitos

- Considerar sistema de criação (HOST) Linux Mint 21.3
- Docker 24.0.5

## Topoligia da Rede

- Topologia de uma rede contando com a internet ligado a um roteador, que passa por um firewall. No firewall, a entrada é a ETH, com duas saídas, ETH0 e ETH1, para a ETH0 passa para uma rede interna para os usuários e um servidor corporativo, já a ETH1 passa por um DMZ e chega a um servidor Web, FTP e emails.

- Configurações da rede:
  - Rede Interna: 10.1.1.0/24 ETH0: 10.1.1.1/24
  - DMZ: 192.168.1.0/24 ETH1: 192.168.1.1/24
  - Rede Externa: 200.20.5.0/30 ETH2: 200.20.5.1/30

## Configuração da Rede do Container

- A rede foi configurada com o nome "rede" e o endereço "192.168.1.0/24", com o comando "sudo docker network create --subnet=192.168.1.0/24 rede".

- Então para que o container esteja dentro da rede se deve usar o "--net rede" no comando de execução para cada container, para que eles possam se comunicar entre si, na mesma rede.

- Para verificar se a rede foi criada use o comando "sudo docker network ls".

## Instruções de Uso

1. Clone o repositório do Github.
2. Acesse-o pelo terminal a pasta onde o projeto foi clonado.
3. Execute o comando "sudo docker build -t orlandofilho04/firewall:latest -f firewall.dockerfile ." para iniciar a criação do container FIREWALL.
4. Após a criação do container FIREWALL, digite "sudo docker run -d --name firewall --restart always --net rede --privileged orlandofilho04/firewall" para iniciar a execução do container FIREWALL.
5. Se necessário adentrar no container em execução use "sudo docker exec -it firewall /bin/bash".
6. Se necessário parar a execução do container "sudo docker stop firewall".

## Funcionamento

- Container FIREWALL: O container foi configurado com um arquivo chamado "firewall_rules.sh", o qual contém as configurações necessárias para o serviço FIREWALL. Seu funcionamento consiste na implementação dos controles de acesso à rede, conforme as regras estabelecidas no enunciado do exercício.

## Testes

- FIREWALL:

1. Acesse o container FIREWALL.
2. Execute o comando "iptables -L" para verificar as regras de firewall.
3. Execute o comando "iptables -t nat -L" para verificar as regras de NAT.
4. Execute o comando "iptables -t mangle -L" para verificar as regras de MANGLE.
5. Execute o comando "iptables -t raw -L" para verificar as regras de RAW.
6. Execute o comando "iptables -t security -L" para verificar as regras de SECURITY.
7. Execute o comando "iptables -t filter -L" para verificar as regras de FILTER.
